import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/setting/bloc/category/category_bloc.dart';
import 'package:restoguh/presentation/setting/bloc/category/category_event.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/image_picker_widget.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';

import '../models/category_model.dart';

class AddCategoryPage extends StatefulWidget {
  final Category? category; // null = add, non-null = edit

  const AddCategoryPage({super.key, this.category});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category?.name ?? '');
    descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Category' : 'Add Category'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(controller: nameController, label: 'Name'),
          const SpaceHeight(16),
          CustomTextField(
            controller: descriptionController,
            label: 'Description',
          ),
          const SpaceHeight(16),
          ImagePickerWidget(
            label: 'Image',
            initialImage: widget.category?.image,
            onChanged: (file) {
              if (file != null) imageFile = File(file.path);
            },
          ),
          const SpaceHeight(20),
          Button.filled(
            label: isEdit ? 'Update' : 'Save',
            onPressed: () {
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name cannot be empty'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (isEdit) {
                context.read<CategoryBloc>().add(
                  UpdateCategory(
                    category: widget.category!,
                    name: name,
                    description: description.isEmpty ? null : description,
                    image: imageFile,
                  ),
                );
              } else {
                context.read<CategoryBloc>().add(
                  AddCategory(
                    name: name,
                    description: description.isEmpty ? null : description,
                    image: imageFile,
                  ),
                );
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
