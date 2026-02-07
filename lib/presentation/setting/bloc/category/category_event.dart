import 'package:equatable/equatable.dart';
import '../../models/category_model.dart';
import 'dart:io';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  final String? description;
  final File? image;

  AddCategory({required this.name, this.description, this.image});

  @override
  List<Object?> get props => [name, description, image];
}

class UpdateCategory extends CategoryEvent {
  final Category category;
  final String name;
  final String? description;
  final File? image;

  UpdateCategory({
    required this.category,
    required this.name,
    this.description,
    this.image,
  });

  @override
  List<Object?> get props => [category, name, description, image];
}

class DeleteCategory extends CategoryEvent {
  final Category category;

  DeleteCategory(this.category);

  @override
  List<Object?> get props => [category];
}
