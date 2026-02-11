// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kitchen_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KitchenOrder _$KitchenOrderFromJson(Map<String, dynamic> json) {
  return _KitchenOrder.fromJson(json);
}

/// @nodoc
mixin _$KitchenOrder {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_time')
  String get transactionTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  int get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems => throw _privateConstructorUsedError;

  /// Serializes this KitchenOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KitchenOrderCopyWith<KitchenOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KitchenOrderCopyWith<$Res> {
  factory $KitchenOrderCopyWith(
    KitchenOrder value,
    $Res Function(KitchenOrder) then,
  ) = _$KitchenOrderCopyWithImpl<$Res, KitchenOrder>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'transaction_time') String transactionTime,
    @JsonKey(name: 'total_price') int totalPrice,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'order_items') List<OrderItem> orderItems,
  });
}

/// @nodoc
class _$KitchenOrderCopyWithImpl<$Res, $Val extends KitchenOrder>
    implements $KitchenOrderCopyWith<$Res> {
  _$KitchenOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionTime = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? orderItems = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            transactionTime: null == transactionTime
                ? _value.transactionTime
                : transactionTime // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            orderItems: null == orderItems
                ? _value.orderItems
                : orderItems // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KitchenOrderImplCopyWith<$Res>
    implements $KitchenOrderCopyWith<$Res> {
  factory _$$KitchenOrderImplCopyWith(
    _$KitchenOrderImpl value,
    $Res Function(_$KitchenOrderImpl) then,
  ) = __$$KitchenOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'transaction_time') String transactionTime,
    @JsonKey(name: 'total_price') int totalPrice,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'order_items') List<OrderItem> orderItems,
  });
}

/// @nodoc
class __$$KitchenOrderImplCopyWithImpl<$Res>
    extends _$KitchenOrderCopyWithImpl<$Res, _$KitchenOrderImpl>
    implements _$$KitchenOrderImplCopyWith<$Res> {
  __$$KitchenOrderImplCopyWithImpl(
    _$KitchenOrderImpl _value,
    $Res Function(_$KitchenOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionTime = null,
    Object? totalPrice = null,
    Object? status = null,
    Object? orderItems = null,
  }) {
    return _then(
      _$KitchenOrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        transactionTime: null == transactionTime
            ? _value.transactionTime
            : transactionTime // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        orderItems: null == orderItems
            ? _value._orderItems
            : orderItems // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KitchenOrderImpl implements _KitchenOrder {
  const _$KitchenOrderImpl({
    required this.id,
    @JsonKey(name: 'transaction_time') required this.transactionTime,
    @JsonKey(name: 'total_price') required this.totalPrice,
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'order_items') required final List<OrderItem> orderItems,
  }) : _orderItems = orderItems;

  factory _$KitchenOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$KitchenOrderImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'transaction_time')
  final String transactionTime;
  @override
  @JsonKey(name: 'total_price')
  final int totalPrice;
  @override
  @JsonKey(name: 'status')
  final String status;
  final List<OrderItem> _orderItems;
  @override
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  @override
  String toString() {
    return 'KitchenOrder(id: $id, transactionTime: $transactionTime, totalPrice: $totalPrice, status: $status, orderItems: $orderItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KitchenOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionTime, transactionTime) ||
                other.transactionTime == transactionTime) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._orderItems,
              _orderItems,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    transactionTime,
    totalPrice,
    status,
    const DeepCollectionEquality().hash(_orderItems),
  );

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KitchenOrderImplCopyWith<_$KitchenOrderImpl> get copyWith =>
      __$$KitchenOrderImplCopyWithImpl<_$KitchenOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KitchenOrderImplToJson(this);
  }
}

abstract class _KitchenOrder implements KitchenOrder {
  const factory _KitchenOrder({
    required final int id,
    @JsonKey(name: 'transaction_time') required final String transactionTime,
    @JsonKey(name: 'total_price') required final int totalPrice,
    @JsonKey(name: 'status') required final String status,
    @JsonKey(name: 'order_items') required final List<OrderItem> orderItems,
  }) = _$KitchenOrderImpl;

  factory _KitchenOrder.fromJson(Map<String, dynamic> json) =
      _$KitchenOrderImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'transaction_time')
  String get transactionTime;
  @override
  @JsonKey(name: 'total_price')
  int get totalPrice;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'order_items')
  List<OrderItem> get orderItems;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KitchenOrderImplCopyWith<_$KitchenOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  int get id => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  Product get product => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({int id, int quantity, Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? product = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            product: null == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int quantity, Product product});

  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? product = null,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final int id;
  @override
  final int quantity;
  @override
  final Product product;

  @override
  String toString() {
    return 'OrderItem(id: $id, quantity: $quantity, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.product, product) || other.product == product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity, product);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final int id,
    required final int quantity,
    required final Product product,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  int get id;
  @override
  int get quantity;
  @override
  Product get product;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get name => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({String name, int price});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? price = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int price});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? price = null}) {
    return _then(
      _$ProductImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({required this.name, required this.price});

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String name;
  @override
  final int price;

  @override
  String toString() {
    return 'Product(name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, price);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String name,
    required final int price,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get name;
  @override
  int get price;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
