import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../features/pos/models/transaction.dart' as TransactionModel;
import 'firebase_service.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(FirebaseService.instance);
});

final businessIdProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
});

final transactionsProvider = StreamProvider<List<TransactionModel.Transaction>>(
  (ref) {
    final transactionService = ref.read(transactionServiceProvider);
    final businessId = ref.watch(businessIdProvider);

    if (businessId == null) {
      return Stream.value([]);
    }

    return transactionService.getTransactionsStream(businessId);
  },
);

final paginatedTransactionsProvider =
    FutureProvider.family<List<TransactionModel.Transaction>, PaginationParams>(
      (ref, params) async {
        final transactionService = ref.read(transactionServiceProvider);
        final businessId = ref.watch(businessIdProvider);

        if (businessId == null) {
          return [];
        }

        if (params.searchQuery.isNotEmpty) {
          return await transactionService.searchTransactions(
            businessId,
            params.searchQuery,
            limit: params.limit,
            startAfter: params.startAfter,
            statusFilter: params.statusFilter,
          );
        } else {
          return await transactionService.getTransactionsPaginated(
            businessId,
            limit: params.limit,
            startAfter: params.startAfter,
            statusFilter: params.statusFilter,
          );
        }
      },
    );

class PaginationParams {
  final int limit;
  final DocumentSnapshot? startAfter;
  final String searchQuery;
  final String statusFilter;

  PaginationParams({
    this.limit = 10,
    this.startAfter,
    this.searchQuery = '',
    this.statusFilter = 'All',
  });

  PaginationParams copyWith({
    int? limit,
    DocumentSnapshot? startAfter,
    String? searchQuery,
    String? statusFilter,
  }) {
    return PaginationParams(
      limit: limit ?? this.limit,
      startAfter: startAfter ?? this.startAfter,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class TransactionService {
  final FirebaseService _firebaseService;
  final Uuid _uuid;

  TransactionService(this._firebaseService) : _uuid = const Uuid();

  Stream<List<TransactionModel.Transaction>> getTransactionsStream(
    String businessId,
  ) {
    return _firebaseService.getTransactionsByBusinessStream(businessId).map((
      snapshot,
    ) {
      final transactions = snapshot.docs
          .map((doc) => _mapDocumentToTransaction(doc))
          .toList();
      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return transactions;
    });
  }

  Future<List<TransactionModel.Transaction>> getTransactionsPaginated(
    String businessId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
    String? statusFilter,
  }) async {
    final snapshot = await _firebaseService.getTransactionsByBusinessPaginated(
      businessId,
      limit: limit,
      startAfter: startAfter,
      statusFilter: statusFilter,
    );

    final transactions = snapshot.docs
        .map((doc) => _mapDocumentToTransaction(doc))
        .toList();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }

  Future<List<TransactionModel.Transaction>> searchTransactions(
    String businessId,
    String searchQuery, {
    int limit = 10,
    DocumentSnapshot? startAfter,
    String? statusFilter,
  }) async {
    final snapshot = await _firebaseService.searchTransactions(
      businessId,
      searchQuery,
      limit: limit,
      startAfter: startAfter,
      statusFilter: statusFilter,
    );

    final allTransactions = snapshot.docs
        .map((doc) => _mapDocumentToTransaction(doc))
        .toList();

    if (searchQuery.isEmpty) {
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allTransactions;
    }

    final searchLower = searchQuery.toLowerCase();
    final filteredTransactions = allTransactions.where((transaction) {
      return transaction.id.toLowerCase().contains(searchLower) ||
          transaction.items.any(
            (item) => item.name.toLowerCase().contains(searchLower),
          ) ||
          transaction.paymentMethod.toLowerCase().contains(searchLower) ||
          transaction.status.toLowerCase().contains(searchLower);
    }).toList();

    filteredTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filteredTransactions;
  }

  TransactionModel.Transaction _mapDocumentToTransaction(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final Map<String, dynamic> transactionData = {
      'id': doc.id,
      'businessId': data['businessId'],
      'items': data['items'],
      'subtotal': data['subtotal'],
      'tax': data['tax'],
      'discount': data['discount'],
      'total': data['total'],
      'paymentMethod': data['paymentMethod'],
      'status': data['status'],
      'createdAt': (data['createdAt'] as Timestamp?)
          ?.toDate()
          .toIso8601String(),
      'updatedAt': (data['updatedAt'] as Timestamp?)
          ?.toDate()
          .toIso8601String(),
      'refundedAt': (data['refundedAt'] as Timestamp?)
          ?.toDate()
          .toIso8601String(),
    };

    return TransactionModel.Transaction.fromJson(transactionData);
  }

  Future<void> createTransaction({
    required String transactionId,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double tax,
    required double discount,
    required double total,
    required String paymentMethod,
    required String status,
  }) async {
    final user = _firebaseService.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firebaseService.createTransaction(
      transactionId: transactionId,
      businessId: user.uid,
      items: items,
      subtotal: subtotal,
      tax: tax,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      status: status,
    );
  }

  Future<void> updateTransactionStatus(
    String transactionId,
    String status,
  ) async {
    await _firebaseService.updateTransactionStatus(transactionId, status);
  }

  Future<TransactionModel.Transaction?> getTransaction(
    String transactionId,
  ) async {
    try {
      final doc = await _firebaseService.getTransaction(transactionId);
      if (doc.exists) {
        return _mapDocumentToTransaction(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }
}
