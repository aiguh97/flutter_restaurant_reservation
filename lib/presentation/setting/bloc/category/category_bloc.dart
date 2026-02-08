import 'dart:io';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/data/models/response/category_response_model.dart';
import 'package:http/http.dart' as http;
import '../../models/category_model.dart';
import 'category_event.dart';
import 'category_state.dart';
import 'package:restoguh/core/constants/variables.dart';

/// Optional: buat datasource/repository agar mudah test
class CategoryRepository {
  final String baseUrl = Variables.baseUrl + '/api/categories';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final resModel = CategoryResponseModel.fromJson(response.body);
      // Convert API response ke Bloc Category
      return resModel.data.map((e) => e.toCategoryBloc()).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<void> addCategory(
    String name, {
    String? description,
    File? image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields['name'] = name;
    if (description != null) request.fields['description'] = description;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201) {
      final body = json.decode(response.body);
      throw Exception(body['errors'] ?? response.body);
    }
  }

  Future<void> updateCategory(
    Category category,
    String name, {
    String? description,
    File? image,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/${category.id}?_method=PUT'),
    );
    request.fields['name'] = name;
    if (description != null) request.fields['description'] = description;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      final body = json.decode(response.body);
      throw Exception(body['errors'] ?? response.body);
    }
  }

  Future<void> deleteCategory(Category category) async {
    final response = await http.delete(Uri.parse('$baseUrl/${category.id}'));
    if (response.statusCode != 200) {
      final body = json.decode(response.body);
      throw Exception(body['errors'] ?? response.body);
    }
  }
}

/// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await repository.addCategory(
        event.name,
        description: event.description,
        image: event.image,
      );
      add(LoadCategories()); // reload
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await repository.updateCategory(
        event.category,
        event.name,
        description: event.description,
        image: event.image,
      );
      add(LoadCategories()); // reload
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await repository.deleteCategory(event.category);
      add(LoadCategories()); // reload
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }
}
