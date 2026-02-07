import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/sync_order/sync_order_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../data/datasources/product_local_datasource.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Data'), centerTitle: true),
      //textfield untuk input server key
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          //button sync data product
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (state) async {
                  await ProductLocalDatasource.instance.removeAllProduct();
                  await ProductLocalDatasource.instance.insertAllProduct(
                    state.products.toList(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Sync data product success'),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        const ProductEvent.fetch(),
                      );
                    },
                    child: const Text('Sync Data Product'),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
          const SpaceHeight(20),
          //button sync data order
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (_) async {
                  // await ProductLocalDatasource.instance.removeAllProduct();
                  // await ProductLocalDatasource.instance
                  //     .insertAllProduct(_.products.toList());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Sync data orders success'),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<SyncOrderBloc>().add(
                        const SyncOrderEvent.sendOrder(),
                      );
                    },
                    child: const Text('Sync Data Orders'),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
          const SpaceHeight(20),

          //button sync categories
          // BlocConsumer<CategoryBloc, CategoryState>(
          //   listener: (context, state) {
          //     state.maybeMap(
          //       loaded: (data) async {
          //         // Simpan ke local
          //         await ProductLocalDatasource.instance.removeAllCategories();
          //         await ProductLocalDatasource.instance.insertAllCategories(
          //           data.categories,
          //         );

          //         // Ambil data lokal lagi
          //         context.read<CategoryBloc>().add(
          //           const CategoryEvent.getCategoriesLocal(),
          //         );

          //         // Tutup halaman jika perlu
          //         Navigator.of(context).pop();

          //         // Tampilkan snackbar sukses
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //             backgroundColor:
          //                 Colors.green, // ganti sesuai AppColors.primary
          //             content: Text('Sync data categories success'),
          //           ),
          //         );
          //       },
          //       orElse: () {},
          //     );
          //   },
          //   builder: (context, state) {
          //     return state.maybeWhen(
          //       loading: () => const Center(child: CircularProgressIndicator()),
          //       orElse: () {
          //         return ElevatedButton(
          //           onPressed: () {
          //             context.read<CategoryBloc>().add(
          //               const CategoryEvent.getCategories(),
          //             );
          //           },
          //           child: const Text('Sync Data Categories'),
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
