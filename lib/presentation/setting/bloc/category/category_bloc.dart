import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/constants/variables.dart';
import '../../models/category_model.dart';
import 'category_event.dart';
import 'category_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final String baseUrl = Variables.baseUrl + '/api/categories';

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  // Load all categories
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'] as List;
        final categories = data.map((e) => Category.fromJson(e)).toList();
        emit(CategoryLoaded(categories));
      } else {
        emit(
          CategoryError('Failed to load categories: ${response.statusCode}'),
        );
      }
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  // Add a new category
  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['name'] = event.name;
      if (event.description != null)
        request.fields['description'] = event.description!;
      if (event.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', event.image!.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 201) {
        add(LoadCategories()); // reload
      } else {
        final body = json.decode(response.body);
        emit(
          CategoryError(
            'Failed to add category: ${body['errors'] ?? response.body}',
          ),
        );
      }
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  // Update category
  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/${event.category.id}?_method=PUT'),
      );

      // Pastikan field tidak null atau kosong
      if (event.name.isEmpty) {
        emit(CategoryError('Name cannot be empty'));
        return;
      }

      request.fields['name'] = event.name;
      if (event.description != null)
        request.fields['description'] = event.description!;
      if (event.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', event.image!.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        add(LoadCategories()); // reload
      } else {
        final body = json.decode(response.body);
        emit(
          CategoryError(
            'Failed to update category: ${body['errors'] ?? response.body}',
          ),
        );
      }
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }

  // Delete category
  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/${event.category.id}'),
      );
      if (response.statusCode == 200) {
        add(LoadCategories()); // reload
      } else {
        final body = json.decode(response.body);
        emit(
          CategoryError(
            'Failed to delete category: ${body['errors'] ?? response.body}',
          ),
        );
      }
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }
}
