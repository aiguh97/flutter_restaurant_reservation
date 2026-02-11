// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitchen_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KitchenOrderImpl _$$KitchenOrderImplFromJson(Map<String, dynamic> json) =>
    _$KitchenOrderImpl(
      id: (json['id'] as num).toInt(),
      transactionTime: json['transaction_time'] as String,
      totalPrice: (json['total_price'] as num).toInt(),
      status: json['status'] as String,
      orderItems: (json['order_items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$KitchenOrderImplToJson(_$KitchenOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_time': instance.transactionTime,
      'total_price': instance.totalPrice,
      'status': instance.status,
      'order_items': instance.orderItems,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'product': instance.product,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{'name': instance.name, 'price': instance.price};
