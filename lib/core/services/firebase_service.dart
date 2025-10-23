import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  static Future<void> initialize() async {
  }

  User? get currentUser => auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');

    await user.updateDisplayName(displayName);
    if (photoURL != null) {
      await user.updatePhotoURL(photoURL);
    }
  }

  Future<void> deleteUser() async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');

    await user.delete();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  CollectionReference get usersCollection => firestore.collection('users');
  CollectionReference get businessesCollection => firestore.collection('businesses');
  CollectionReference get productsCollection => firestore.collection('products');
  CollectionReference get transactionsCollection => firestore.collection('transactions');

  Future<void> createUserDocument({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String? businessName,
  }) async {
    await usersCollection.doc(uid).set({
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'businessName': businessName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserDocument(String uid) async {
    return await usersCollection.doc(uid).get();
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await usersCollection.doc(uid).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateBusinessName(String businessName) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }
      
      await usersCollection.doc(user.uid).update({
        'businessName': businessName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update business name: $e');
    }
  }

  Future<String?> getBusinessName() async {
    try {
      final user = currentUser;
      if (user == null) {
        return null;
      }
      
      final doc = await usersCollection.doc(user.uid).get();
      final data = doc.data() as Map<String, dynamic>?;
      return data?['businessName'] as String?;
    } catch (e) {
      throw Exception('Failed to get business name: $e');
    }
  }

  Future<void> createBusinessDocument({
    required String businessId,
    required String ownerId,
    required String businessName,
    String? businessLogo,
    String? businessAddress,
    String? businessPhone,
    String? businessEmail,
  }) async {
    await businessesCollection.doc(businessId).set({
      'ownerId': ownerId,
      'businessName': businessName,
      'businessLogo': businessLogo,
      'businessAddress': businessAddress,
      'businessPhone': businessPhone,
      'businessEmail': businessEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getBusinessDocument(String businessId) async {
    return await businessesCollection.doc(businessId).get();
  }

  Future<QuerySnapshot> getBusinessesByOwner(String ownerId) async {
    return await businessesCollection
        .where('ownerId', isEqualTo: ownerId)
        .get();
  }

  Future<void> createProductDocument({
    required String productId,
    required String businessId,
    required String name,
    required String description,
    required double price,
    required String sku,
    required String category,
    required int stock,
    required int minStock,
    String? imageUrl,
    bool isActive = true,
  }) async {
    await productsCollection.doc(productId).set({
      'businessId': businessId,
      'name': name,
      'description': description,
      'price': price,
      'sku': sku,
      'category': category,
      'stock': stock,
      'minStock': minStock,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> getProductsByBusiness(String businessId) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .get();
  }

  Future<QuerySnapshot> getActiveProductsByBusiness(String businessId) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('isActive', isEqualTo: true)
        .get();
  }

  Future<DocumentSnapshot> getProduct(String productId) async {
    return await productsCollection.doc(productId).get();
  }

  Future<void> updateProductDocument(String productId, Map<String, dynamic> data) async {
    await productsCollection.doc(productId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProductDocument(String productId) async {
    await productsCollection.doc(productId).delete();
  }

  Future<void> updateProductStock(String productId, int newStock) async {
    await productsCollection.doc(productId).update({
      'stock': newStock,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> searchProducts(String businessId, String searchQuery) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('isActive', isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getProductsByCategory(String businessId, String category) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .get();
  }

  Future<QuerySnapshot> getLowStockProducts(String businessId) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('isActive', isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getOutOfStockProducts(String businessId) async {
    return await productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('stock', isEqualTo: 0)
        .where('isActive', isEqualTo: true)
        .get();
  }

  Future<void> createTransactionDocument({
    required String transactionId,
    required String businessId,
    required List<Map<String, dynamic>> items,
    required double total,
    required String paymentMethod,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
  }) async {
    await transactionsCollection.doc(transactionId).set({
      'businessId': businessId,
      'items': items,
      'total': total,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'status': 'Completed',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> getTransactionsByBusiness(String businessId) async {
    return await transactionsCollection
        .where('businessId', isEqualTo: businessId)
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<String> uploadFile({
    required String path,
    required Uint8List data,
    String? contentType,
  }) async {
    try {
      final ref = storage.ref().child(path);
      final uploadTask = ref.putData(
        data,
        SettableMetadata(contentType: contentType),
      );
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final ref = storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<void> createTransaction({
    required String transactionId,
    required String businessId,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double tax,
    required double discount,
    required double total,
    required String paymentMethod,
    required String status,
  }) async {
    await transactionsCollection.doc(transactionId).set({
      'businessId': businessId,
      'items': items,
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTransactionsByBusinessStream(String businessId) {
    return transactionsCollection
        .where('businessId', isEqualTo: businessId)
        .snapshots();
  }

  Future<QuerySnapshot> getTransactionsByBusinessPaginated(
    String businessId, {
    int limit = 10,
    DocumentSnapshot? startAfter,
    String? statusFilter,
  }) async {
    Query query = transactionsCollection
        .where('businessId', isEqualTo: businessId)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (statusFilter != null && statusFilter != 'All') {
      query = query.where('status', isEqualTo: statusFilter);
    }

    return await query.get();
  }

  Future<QuerySnapshot> searchTransactions(
    String businessId,
    String searchQuery, {
    int limit = 10,
    DocumentSnapshot? startAfter,
    String? statusFilter,
  }) async {
    Query query = transactionsCollection
        .where('businessId', isEqualTo: businessId)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (statusFilter != null && statusFilter != 'All') {
      query = query.where('status', isEqualTo: statusFilter);
    }

    return await query.get();
  }

  Future<void> updateTransactionStatus(String transactionId, String status) async {
    await transactionsCollection.doc(transactionId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      if (status == 'Refunded') 'refundedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getTransaction(String transactionId) async {
    return await transactionsCollection.doc(transactionId).get();
  }
}
