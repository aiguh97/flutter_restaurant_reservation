// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderResponseModelImpl _$$OrderResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderResponseModelImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => Order.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$OrderResponseModelImplToJson(
  _$OrderResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: (json['id'] as num).toInt(),
  transactionTime: json['transaction_time'] as String,
  totalPrice: (json['total_price'] as num).toInt(),
  totalItem: (json['total_item'] as num).toInt(),
  paymentMethod: json['payment_method'] as String,
  status: json['status'] as String,
  tableNumber: json['table_number'],
  orderItems: (json['order_items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_time': instance.transactionTime,
      'total_price': instance.totalPrice,
      'total_item': instance.totalItem,
      'payment_method': instance.paymentMethod,
      'status': instance.status,
      'table_number': instance.tableNumber,
      'order_items': instance.orderItems,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['total_price'] as num).toInt(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
      'product': instance.product,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'image': instance.image,
    };
