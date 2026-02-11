import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_response_model.freezed.dart';
part 'order_response_model.g.dart';

@freezed
class OrderResponseModel with _$OrderResponseModel {
  const factory OrderResponseModel({
    required bool success,
    required List<Order> data,
  }) = _OrderResponseModel;

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    @JsonKey(name: 'transaction_time') required String transactionTime,
    @JsonKey(name: 'total_price') required int totalPrice,
    @JsonKey(name: 'total_item') required int totalItem,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required String status,
    @JsonKey(name: 'table_number') required dynamic tableNumber,
    @JsonKey(name: 'order_items') required List<OrderItem> orderItems,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required int quantity,
    @JsonKey(name: 'total_price') required int totalPrice,
    required Product product,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required int price,
    String? image,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
