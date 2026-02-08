import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_pos_2/core/constants/variables.dart';
import 'package:flutter_pos_2/data/models/request/product_request_model.dart';
import 'package:flutter_pos_2/data/models/response/add_product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pos_2/data/models/response/product_response_model.dart';
import 'auth_local_datasource.dart';
import 'package:path/path.dart'; // untuk basename()

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    // 1. Tambahkan pengecekan ini
    if (authData == null || authData.token == null) {
      return left('Sesi login berakhir');
    }
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/products'),
      headers: {'Authorization': 'Bearer ${authData.token}'},
    );

    if (response.statusCode == 200) {
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, ProductResponseModel>> updateProduct(
    ProductRequestModel product,
  ) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      // 1. Tambahkan pengecekan ini
      if (authData == null || authData.token == null) {
        return left('Sesi login berakhir');
      }
      // Gunakan Uri.parse yang bersih
      final url = Uri.parse('${Variables.baseUrl}/api/products/${product.id}');

      var request = http.MultipartRequest('POST', url);

      // Tambahkan Header (Sangat Penting)
      request.headers.addAll({
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      // Method Spoofing
      request.fields['_method'] = 'PUT';

      // Isi data lainnya
      request.fields['name'] = product.name;
      request.fields['price'] = product.price.toString();
      request.fields['stock'] = product.stock.toString();
      request.fields['category_id'] = product.categoryId.toString();

      // Kirim file jika ada
      if (product.image != null) {
        final file = File(product.image!.path);
        if (await file.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              file.path,
              filename: basename(file.path),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return right(ProductResponseModel.fromJson(response.body));
      } else {
        // Log body agar kita tahu jika ada error validasi lagi
        print("Error Update: ${response.body}");
        return left('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      return left('Exception: $e');
    }
  }

  Future<Either<String, void>> deleteProduct(int id) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      // 1. Tambahkan pengecekan ini
      if (authData == null || authData.token == null) {
        return left('Sesi login berakhir');
      }
      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/products/$id'),
        headers: {'Authorization': 'Bearer ${authData.token}'},
      );

      if (response.statusCode == 200) {
        return right(null);
      } else {
        return left('Gagal menghapus produk: ${response.body}');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct(
    ProductRequestModel productRequestModel,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    // 1. Tambahkan pengecekan ini
    if (authData == null || authData.token == null) {
      return left('Sesi login berakhir');
    }
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/products'),
    );
    request.fields.addAll(productRequestModel.toMap());
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        productRequestModel.image!.path,
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return right(AddProductResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }
}
