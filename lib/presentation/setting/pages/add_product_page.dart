import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/extensions/string_ext.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_state.dart';
import 'package:flutter_pos_2/presentation/setting/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_event.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_dropdown.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/image_picker_widget.dart';
import '../../../core/components/spaces.dart';
import '../../../data/models/response/product_response_model.dart';
import '../../home/bloc/product/product_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController? nameController;
  TextEditingController? priceController;
  TextEditingController? stockController;

  Category? selectedCategory; // gunakan Category dari API

  XFile? imageFile;

  bool isBestSeller = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    stockController = TextEditingController();

    // Load categories dari API
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  void dispose() {
    nameController!.dispose();
    priceController!.dispose();
    stockController!.dispose();
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
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(controller: nameController!, label: 'Product Name'),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController!,
            label: 'Product Price',
            keyboardType: TextInputType.number,
          ),
          const SpaceHeight(16.0),
          ImagePickerWidget(
            label: 'Photo',
            onChanged: (file) {
              if (file != null) imageFile = file;
            },
          ),
          const SpaceHeight(16.0),
          CustomTextField(
            controller: stockController!,
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

          /// Dropdown Category dari API
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              List<Category> categories = [];
              if (state is CategoryLoaded) {
                categories = state.categories;
              }

              return CustomDropdown<String>(
                value: selectedCategory?.name,
                items: categories.map((e) => e.name).toList(),
                label: 'Category',
                onChanged: (value) {
                  setState(() {
                    selectedCategory = categories.firstWhere(
                      (c) => c.name == value,
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
                      success: (_) => Navigator.pop(context),
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: () {
                        if (selectedCategory == null || imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Category and image are required'),
                            ),
                          );

                          return;
                        }

                        final product = Product(
                          name: nameController!.text,
                          price: priceController!.text.toIntegerFromText,
                          stock: stockController!.text.toIntegerFromText,
                          category: selectedCategory!.name,
                          categoryId: selectedCategory!.id,
                          isBestSeller: isBestSeller,
                          image: imageFile!.path,
                        );

                        context.read<ProductBloc>().add(
                          ProductEvent.addProduct(product, imageFile!),
                        );
                      },
                      label: 'Simpan',
                    );
                  },
                ),
              ),
            ],
          ),
          const SpaceHeight(20.0),
        ],
      ),
    );
  }
}
