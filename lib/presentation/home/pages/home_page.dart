import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/core/extensions/build_context_ext.dart';
import 'package:restoguh/presentation/draft_order/pages/draft_order_page.dart';
import 'package:restoguh/presentation/home/bloc/product/product_bloc.dart';
import 'package:restoguh/presentation/setting/bloc/category/category_bloc.dart';
import 'package:restoguh/presentation/setting/bloc/category/category_event.dart';
import 'package:restoguh/presentation/setting/bloc/category/category_state.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/search_input.dart';
import '../../../core/components/spaces.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../widgets/product_card.dart';
import '../widgets/product_empty.dart';
import '../widgets/product_skeleton.dart'; // buat skeleton widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Connect printer (jika ada)
    AuthLocalDatasource().getPrinter().then((value) async {
      if (value.isNotEmpty) {
        await PrintBluetoothThermal.connect(macPrinterAddress: value);
      }
    });
  }

  void _fetchData() {
    // Fetch semua produk
    context.read<ProductBloc>().add(const ProductEvent.fetch());
    // Fetch kategori
    context.read<CategoryBloc>().add(LoadCategories());
  }

  void onCategoryTap(int index, String categoryName) {
    currentIndex = index;
    searchController.clear();

    if (categoryName == 'all') {
      context.read<ProductBloc>().add(const ProductEvent.fetch());
    } else {
      context.read<ProductBloc>().add(
        ProductEvent.fetchByCategory(categoryName),
      );
    }
  }

  Future<void> _onRefresh() async {
    _fetchData();
    // Tunggu hingga ProductBloc selesai loading
    await context.read<ProductBloc>().stream.firstWhere((state) {
      return state.maybeWhen(
        orElse: () => true, // semua state selain loading
        loading: () => false, // masih loading, tunggu
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Menu Cafe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(const DraftOrderPage());
            },
            icon: const Icon(Icons.note_alt_rounded),
          ),
          const SpaceWidth(8),
        ],
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SearchInput(
              controller: searchController,
              onChanged: (value) {
                if (value.length > 3) {
                  context.read<ProductBloc>().add(
                    ProductEvent.searchProduct(value),
                  );
                }
                if (value.isEmpty) {
                  context.read<ProductBloc>().add(
                    const ProductEvent.fetchAllFromState(),
                  );
                }
              },
            ),
            const SpaceHeight(16.0),

            // CATEGORY MENU
            // CATEGORY MENU
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return SizedBox(
                    height:
                        110, // Ditingkatkan dari 90 ke 110 agar tidak overflow
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, __) => MenuButton(
                        // Jangan biarkan kosong agar tidak error "Unable to load asset"
                        iconPath: Assets.icons.allCategories.path,
                        label: 'Loading..',
                        isActive: false,
                        onPressed: () {},
                        isImage:
                            false, // Gunakan false agar tidak mencoba load asset kosong
                      ),
                    ),
                  );
                } else if (state is CategoryError) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryLoaded) {
                  final categories = state.categories;
                  return SizedBox(
                    height:
                        110, // Ditingkatkan agar Text di bawah icon tidak terpotong
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            width: 80, // Sesuaikan lebar agar proporsional
                            child: MenuButton(
                              iconPath: Assets.icons.allCategories.path,
                              label: 'All',
                              size: 66,
                              isActive: currentIndex == 0,
                              onPressed: () {
                                setState(() => currentIndex = 0);
                                onCategoryTap(0, 'all');
                              },
                            ),
                          );
                        } else {
                          final e = categories[index - 1];
                          return SizedBox(
                            width: 80,
                            child: MenuButton(
                              size: 41,
                              iconPath:
                                  '${Variables.baseUrl}/storage/categories/${e.image ?? 'default.png'}',
                              label: e.name,
                              isActive: currentIndex == e.id,
                              isNetwork:
                                  true, // Pastikan MenuButton mendukung network image
                              onPressed: () {
                                setState(() => currentIndex = e.id);
                                onCategoryTap(e.id, e.name);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SpaceHeight(16.0),

            // PRODUCT GRID
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  loading: () {
                    // Skeleton product grid
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                          ),
                      itemBuilder: (_, __) => const ProductSkeleton(),
                    );
                  },
                  error: (message) => Center(child: Text(message)),
                  success: (products) {
                    if (products.isEmpty) return const ProductEmpty();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                          ),
                      itemBuilder: (context, index) =>
                          ProductCard(data: products[index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
