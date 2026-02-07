import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/category/category_event.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/image_picker_widget.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? imageFile; // tetap File? untuk multipart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category'), centerTitle: true),
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
            onChanged: (file) {
              // Convert XFile? -> File?
              if (file != null) {
                imageFile = File(file.path);
              }
            },
          ),
          const SpaceHeight(20),
          Button.filled(
            label: 'Save',
            onPressed: () {
              final String name = nameController.text.trim();
              final String description = descriptionController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name cannot be empty'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              context.read<CategoryBloc>().add(
                AddCategory(
                  name: name,
                  description: description.isEmpty ? null : description,
                  image: imageFile,
                ),
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
