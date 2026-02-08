import 'package:bloc/bloc.dart';
import 'package:flutter_pos_2/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos_2/data/datasources/product_remote_datasource.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/request/product_request_model.dart';
import '../../../../data/models/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];

  ProductBloc(this._productRemoteDatasource) : super(const _Initial()) {
    // FETCH ALL PRODUCTS
    on<_Fetch>((event, emit) async {
      emit(const ProductState.loading());
      final response = await _productRemoteDatasource.getProducts();
      response.fold((l) => emit(ProductState.error(l)), (r) {
        products = r.data;
        emit(ProductState.success(r.data));
      });
    });

    // FETCH LOCAL PRODUCTS
    on<_FetchLocal>((event, emit) async {
      emit(const ProductState.loading());
      final localProducts = await ProductLocalDatasource.instance
          .getAllProduct();
      products = localProducts;
      emit(ProductState.success(products));
    });

    // UPDATE PRODUCT
    // UPDATE PRODUCT
    on<_UpdateProduct>((event, emit) async {
      // 1. Ambil list produk terakhir dari state sebelum berubah jadi loading
      final currentState = state;
      List<Product> oldProducts = [];
      if (currentState is _Success) {
        oldProducts = List<Product>.from(currentState.products);
      }

      emit(const ProductState.loading());

      final requestData = ProductRequestModel(
        id: event.product.id,
        name: event.product.name,
        price: event.product.price,
        stock: event.product.stock,
        category: event.product.category ?? '',
        categoryId: event.product.categoryId ?? 0,
        isBestSeller: event.product.isBestSeller ? 1 : 0,
        image: event.image,
      );

      final response = await _productRemoteDatasource.updateProduct(
        requestData,
      );

      response.fold((l) => emit(ProductState.error(l)), (r) {
        // 2. Jika server sukses, jangan hanya update list lokal.
        // Cara paling aman: Panggil fetch() agar data sinkron dengan database
        add(const ProductEvent.fetch());

        // Atau jika ingin update manual di list (agar cepat tanpa loading server lagi):
        /*
      if (r.data.isNotEmpty) {
        final updatedProduct = r.data.first;
        final index = oldProducts.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          oldProducts[index] = updatedProduct;
        }
      }
      emit(ProductState.success(oldProducts));
      */
      });
    });
    // ADD PRODUCT
    on<_AddProduct>((event, emit) async {
      emit(const ProductState.loading());

      final requestData = ProductRequestModel(
        name: event.product.name,
        price: event.product.price,
        stock: event.product.stock,
        category: event.product.category ?? '',
        categoryId: event.product.categoryId ?? 0,
        isBestSeller: event.product.isBestSeller ? 1 : 0,
        image: event.image,
      );

      final response = await _productRemoteDatasource.addProduct(requestData);

      response.fold((l) => emit(ProductState.error(l)), (r) {
        products.add(r.data);
        emit(ProductState.success(products));
      });
    });

    // DELETE PRODUCT
    on<_DeleteProduct>((event, emit) async {
      emit(const ProductState.loading());

      final response = await _productRemoteDatasource.deleteProduct(
        event.productId,
      );

      response.fold((l) => emit(ProductState.error(l)), (_) {
        products.removeWhere((p) => p.id == event.productId);
        emit(ProductState.success(products));
      });
    });

    // FETCH BY CATEGORY
    on<_FetchByCategory>((event, emit) async {
      emit(const ProductState.loading());

      final newProducts = event.category == 'all'
          ? products
          : products.where((p) => p.category == event.category).toList();

      emit(ProductState.success(newProducts));
    });

    // SEARCH PRODUCT
    on<_SearchProduct>((event, emit) async {
      emit(const ProductState.loading());

      final newProducts = products
          .where(
            (p) => p.name.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();

      emit(ProductState.success(newProducts));
    });

    // FETCH ALL FROM STATE
    on<_FetchAllFromState>((event, emit) async {
      emit(const ProductState.loading());
      emit(ProductState.success(products));
    });
  }
}
