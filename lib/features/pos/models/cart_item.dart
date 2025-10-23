import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItemData with _$CartItemData {
  const factory CartItemData({
    required String id,
    required Product product,
    required int quantity,
    required double price,
    double? discount,
    String? notes,
  }) = _CartItemData;

  factory CartItemData.fromJson(Map<String, dynamic> json) => _$CartItemDataFromJson(json);
}
