// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartItemData _$CartItemDataFromJson(Map<String, dynamic> json) {
  return _CartItemData.fromJson(json);
}

/// @nodoc
mixin _$CartItemData {
  String get id => throw _privateConstructorUsedError;
  Product get product => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get discount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CartItemData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemDataCopyWith<CartItemData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemDataCopyWith<$Res> {
  factory $CartItemDataCopyWith(
    CartItemData value,
    $Res Function(CartItemData) then,
  ) = _$CartItemDataCopyWithImpl<$Res, CartItemData>;
  @useResult
  $Res call({
    String id,
    Product product,
    int quantity,
    double price,
    double? discount,
    String? notes,
  });

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$CartItemDataCopyWithImpl<$Res, $Val extends CartItemData>
    implements $CartItemDataCopyWith<$Res> {
  _$CartItemDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? quantity = null,
    Object? price = null,
    Object? discount = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            product: null == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as Product,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CartItemData
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
abstract class _$$CartItemDataImplCopyWith<$Res>
    implements $CartItemDataCopyWith<$Res> {
  factory _$$CartItemDataImplCopyWith(
    _$CartItemDataImpl value,
    $Res Function(_$CartItemDataImpl) then,
  ) = __$$CartItemDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Product product,
    int quantity,
    double price,
    double? discount,
    String? notes,
  });

  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$CartItemDataImplCopyWithImpl<$Res>
    extends _$CartItemDataCopyWithImpl<$Res, _$CartItemDataImpl>
    implements _$$CartItemDataImplCopyWith<$Res> {
  __$$CartItemDataImplCopyWithImpl(
    _$CartItemDataImpl _value,
    $Res Function(_$CartItemDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItemData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? quantity = null,
    Object? price = null,
    Object? discount = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$CartItemDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: freezed == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemDataImpl implements _CartItemData {
  const _$CartItemDataImpl({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    this.discount,
    this.notes,
  });

  factory _$CartItemDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemDataImplFromJson(json);

  @override
  final String id;
  @override
  final Product product;
  @override
  final int quantity;
  @override
  final double price;
  @override
  final double? discount;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CartItemData(id: $id, product: $product, quantity: $quantity, price: $price, discount: $discount, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, product, quantity, price, discount, notes);

  /// Create a copy of CartItemData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemDataImplCopyWith<_$CartItemDataImpl> get copyWith =>
      __$$CartItemDataImplCopyWithImpl<_$CartItemDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemDataImplToJson(this);
  }
}

abstract class _CartItemData implements CartItemData {
  const factory _CartItemData({
    required final String id,
    required final Product product,
    required final int quantity,
    required final double price,
    final double? discount,
    final String? notes,
  }) = _$CartItemDataImpl;

  factory _CartItemData.fromJson(Map<String, dynamic> json) =
      _$CartItemDataImpl.fromJson;

  @override
  String get id;
  @override
  Product get product;
  @override
  int get quantity;
  @override
  double get price;
  @override
  double? get discount;
  @override
  String? get notes;

  /// Create a copy of CartItemData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemDataImplCopyWith<_$CartItemDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
