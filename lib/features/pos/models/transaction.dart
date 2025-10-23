import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String businessId,
    required List<TransactionItem> items,
    required double subtotal,
    required double tax,
    required double discount,
    required double total,
    required String paymentMethod,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? refundedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@freezed
class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    required String productId,
    required String name,
    required double price,
    required int quantity,
    required double subtotal,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) => _$TransactionItemFromJson(json);
}
