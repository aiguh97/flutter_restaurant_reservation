import 'package:freezed_annotation/freezed_annotation.dart';

part 'kitchen_order_model.freezed.dart';
part 'kitchen_order_model.g.dart';

@freezed
class KitchenOrder with _$KitchenOrder {
  const factory KitchenOrder({
    required int id,
    @JsonKey(name: 'transaction_time') required String transactionTime,
    @JsonKey(name: 'total_price') required int totalPrice,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'order_items') required List<OrderItem> orderItems,
  }) = _KitchenOrder;

  factory KitchenOrder.fromJson(Map<String, dynamic> json) =>
      _$KitchenOrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required int quantity,
    required Product product,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({required String name, required int price}) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
