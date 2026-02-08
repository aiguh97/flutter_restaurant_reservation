import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/extensions/string_ext.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_state.dart';
import 'package:flutter_pos_2/presentation/setting/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_event.dart';
import '../../home/bloc/product/product_bloc.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_dropdown.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/image_picker_widget.dart';
import '../../../core/components/spaces.dart';
import '../../../data/models/response/product_response_model.dart';

class AddProductPage extends StatefulWidget {
  final Product? product; // optional untuk edit
  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  Category? selectedCategory; // kategori dari API
  XFile? imageFile; // image baru
  bool isBestSeller = false;

  bool get isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
    isBestSeller = widget.product?.isBestSeller ?? false;

    // Load categories dari API
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Edit Product' : 'Add Product',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Product Name',
              ),
              const SpaceHeight(16.0),
              CustomTextField(
                controller: priceController,
                label: 'Product Price',
                keyboardType: TextInputType.number,
              ),
              const SpaceHeight(16.0),
              ImagePickerWidget(
                label: 'Photo',
                initialImage: widget.product?.image,
                onChanged: (file) {
                  if (file != null) setState(() => imageFile = file);
                },
              ),
              const SpaceHeight(16.0),
              CustomTextField(
                controller: stockController,
                label: 'Stock',
                keyboardType: TextInputType.number,
              ),
              const SpaceHeight(16.0),
              Row(
                children: [
                  Checkbox(
                    value: isBestSeller,
                    onChanged: (value) => setState(() => isBestSeller = value!),
                  ),
                  const Text('Best Seller'),
                ],
              ),
              const SpaceHeight(16.0),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  List<Category> categories = [];
                  if (state is CategoryLoaded) {
                    categories = state.categories;

                    // set default category
                    if (selectedCategory == null && categories.isNotEmpty) {
                      selectedCategory = categories.firstWhere(
                        (c) => c.name == widget.product?.category,
                        orElse: () => categories.first,
                      );
                    }
                  }

                  return CustomDropdown<String>(
                    value: selectedCategory?.name,
                    items: categories.map((e) => e.name).toList(),
                    label: 'Category',
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedCategory = categories.firstWhere(
                          (c) => c.name == value,
                          orElse: () => categories.first,
                        );
                      });
                    },
                  );
                },
              ),
              const SpaceHeight(16.0),
              Row(
                children: [
                  Expanded(
                    child: Button.outlined(
                      onPressed: () => Navigator.pop(context),
                      label: 'Batal',
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Expanded(
                    child: BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        state.maybeMap(
                          success: (_) {
                            // Tampilkan alert sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditMode
                                      ? 'Produk berhasil diupdate!'
                                      : 'Produk berhasil ditambahkan!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Beri jeda sedikit agar user bisa membaca alert sebelum berpindah halaman
                            Navigator.pop(context);
                          },
                          error: (e) {
                            // Tampilkan alert jika gagal dari server
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal: ${e.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          orElse: () {},
                        );
                      },
                      builder: (context, state) {
                        // Tampilkan loading saat proses simpan
                        return state.maybeWhen(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          orElse: () => Button.filled(
                            onPressed: () {
                              // Validasi input
                              if (selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Kategori harus dipilih'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              final product = Product(
                                id: widget.product?.id ?? 0,
                                name: nameController.text,
                                price: priceController.text.toIntegerFromText,
                                stock: stockController.text.toIntegerFromText,
                                category: selectedCategory!.name,
                                categoryId: selectedCategory!.id,
                                isBestSeller: isBestSeller,
                                image:
                                    widget.product?.image ??
                                    '', // jangan pakai XFile
                              );

                              if (isEditMode) {
                                context.read<ProductBloc>().add(
                                  ProductEvent.updateProduct(
                                    product,
                                    imageFile,
                                  ),
                                );
                              } else {
                                context.read<ProductBloc>().add(
                                  ProductEvent.addProduct(product, imageFile!),
                                );
                              }
                            },
                            label: isEditMode ? 'Update' : 'Simpan',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
            ],
          ),
        ),
      ),
    );
  }
}
