import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:restoguh/data/models/request/product_request_model.dart';
import 'package:restoguh/data/models/response/add_product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:restoguh/data/models/response/product_response_model.dart';
import 'auth_local_datasource.dart';

class ProductRemoteDatasource {
  Future<Map<String, String>> _getHeaders() async {
    final authData = await AuthLocalDatasource().getAuthData();

    if (authData == null || authData.token == null) {
      throw Exception("Session expired");
    }

    return {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    };
  }

  // ================= GET PRODUCTS =================

  Future<Either<String, ProductResponseModel>> getProducts() async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return right(ProductResponseModel.fromJson(response.body));
      }

      return left("Error ${response.statusCode}: ${response.body}");
    } catch (e) {
      return left(e.toString());
    }
  }

  // ================= UPDATE PRODUCT =================

  Future<Either<String, ProductResponseModel>> updateProduct(
    ProductRequestModel product,
  ) async {
    try {
      final headers = await _getHeaders();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/api/products/${product.id}'),
      );

      request.headers.addAll(headers);

      request.fields['_method'] = 'PUT';
      request.fields['name'] = product.name;
      request.fields['price'] = product.price.toString();
      request.fields['stock'] = product.stock.toString();
      request.fields['category_id'] = product.categoryId.toString();

      if (product.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', product.image!.path),
        );
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return right(ProductResponseModel.fromJson(response.body));
      }

      return left(response.body);
    } catch (e) {
      return left(e.toString());
    }
  }

  // ================= DELETE =================

  Future<Either<String, void>> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/products/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) return right(null);

      return left(response.body);
    } catch (e) {
      return left(e.toString());
    }
  }

  // ================= ADD PRODUCT =================

  Future<Either<String, AddProductResponseModel>> addProduct(
    ProductRequestModel model,
  ) async {
    try {
      final headers = await _getHeaders();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/api/products'),
      );

      request.headers.addAll(headers);
      request.fields.addAll(model.toMap());

      if (model.image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', model.image!.path),
        );
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        return right(AddProductResponseModel.fromJson(response.body));
      }

      return left(response.body);
    } catch (e) {
      return left(e.toString());
    }
  }
}
