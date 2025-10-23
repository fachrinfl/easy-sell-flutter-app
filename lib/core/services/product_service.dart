import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/pos/models/product.dart';
import 'firebase_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(FirebaseService.instance);
});

final businessIdProvider = Provider<String?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  final businessId = user?.uid;
  return businessId;
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  final productService = ref.read(productServiceProvider);
  final businessId = ref.watch(businessIdProvider);

  if (businessId == null) {
    return Stream.value([]);
  }

  return productService.getProductsStream(businessId);
});

final activeProductsProvider = StreamProvider<List<Product>>((ref) {
  final productService = ref.read(productServiceProvider);
  final businessId = ref.watch(businessIdProvider);

  if (businessId == null) {
    return Stream.value([]);
  }

  return productService.getActiveProductsStream(businessId);
});

final productStatsProvider = StreamProvider<ProductStats>((ref) {
  final businessId = ref.watch(businessIdProvider);

  if (businessId == null) {
    return Stream.value(
      ProductStats(totalProducts: 0, lowStock: 0, outOfStock: 0),
    );
  }

  return ref
      .watch(productsProvider)
      .when(
        data: (products) {
          final totalProducts = products.length;
          final lowStock = products
              .where((p) => p.stock > 0 && p.stock <= p.minStock)
              .length;
          final outOfStock = products.where((p) => p.stock == 0).length;

          return Stream.value(
            ProductStats(
              totalProducts: totalProducts,
              lowStock: lowStock,
              outOfStock: outOfStock,
            ),
          );
        },
        loading: () => Stream.value(
          ProductStats(totalProducts: 0, lowStock: 0, outOfStock: 0),
        ),
        error: (error, stack) => Stream.value(
          ProductStats(totalProducts: 0, lowStock: 0, outOfStock: 0),
        ),
      );
});

class ProductStats {
  final int totalProducts;
  final int lowStock;
  final int outOfStock;

  ProductStats({
    required this.totalProducts,
    required this.lowStock,
    required this.outOfStock,
  });
}

final productByIdProvider = FutureProvider.family<Product?, String>((
  ref,
  productId,
) async {
  final productService = ref.read(productServiceProvider);
  return await productService.getProductById(productId);
});

final productByIdStreamProvider = StreamProvider.family<Product?, String>((
  ref,
  productId,
) async* {
  final productService = ref.read(productServiceProvider);
  final businessId = ref.read(businessIdProvider);

  if (businessId == null) {
    yield null;
    return;
  }

  await for (final products in productService.getProductsStream(businessId)) {
    try {
      final product = products.firstWhere((p) => p.id == productId);
      yield product;
    } catch (e) {
      yield null;
    }
  }
});

class ProductService {
  final FirebaseService _firebaseService;

  ProductService(this._firebaseService);

  Stream<List<Product>> getProductsStream(String businessId) {
    return _firebaseService.productsCollection
        .where('businessId', isEqualTo: businessId)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => _mapDocumentToProduct(doc))
              .toList();
          products.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });
          return products;
        });
  }

  Stream<List<Product>> getActiveProductsStream(String businessId) {
    return _firebaseService.productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => _mapDocumentToProduct(doc))
              .toList();
          products.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });
          return products;
        });
  }

  Stream<List<Product>> getProductsByCategoryStream(
    String businessId,
    String category,
  ) {
    return _firebaseService.productsCollection
        .where('businessId', isEqualTo: businessId)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _mapDocumentToProduct(doc)).toList(),
        );
  }

  Future<void> createProduct({
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
    try {
      final businessId = FirebaseAuth.instance.currentUser?.uid;
      if (businessId == null) {
        throw Exception('No authenticated user');
      }

      final productId = _firebaseService.productsCollection.doc().id;

      await _firebaseService.createProductDocument(
        productId: productId,
        businessId: businessId,
        name: name,
        description: description,
        price: price,
        sku: sku,
        category: category,
        stock: stock,
        minStock: minStock,
        imageUrl: imageUrl,
        isActive: isActive,
      );
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<void> updateProduct({
    required String productId,
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
    try {
      await _firebaseService.updateProductDocument(productId, {
        'name': name,
        'description': description,
        'price': price,
        'sku': sku,
        'category': category,
        'stock': stock,
        'minStock': minStock,
        'imageUrl': imageUrl,
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteProductDocument(productId);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<void> updateStock(String productId, int newStock) async {
    try {
      await _firebaseService.updateProductStock(productId, newStock);
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firebaseService.getProduct(productId);
      if (doc.exists) {
        return _mapDocumentToProduct(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  Future<Product?> getProductById(String productId) async {
    return getProduct(productId);
  }

  Future<List<Product>> searchProducts(String businessId, String query) async {
    try {
      final snapshot = await _firebaseService.getProductsByBusiness(businessId);
      final products = snapshot.docs
          .map((doc) => _mapDocumentToProduct(doc))
          .toList();

      return products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.sku.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<ProductStats> getProductStats(String businessId) async {
    try {
      final snapshot = await _firebaseService.getProductsByBusiness(businessId);
      final products = snapshot.docs
          .map((doc) => _mapDocumentToProduct(doc))
          .toList();

      int totalProducts = products.length;
      int lowStock = 0;
      int outOfStock = 0;

      for (final product in products) {
        if (product.stock == 0) {
          outOfStock++;
        } else if (product.stock <= product.minStock) {
          lowStock++;
        }
      }

      return ProductStats(
        totalProducts: totalProducts,
        lowStock: lowStock,
        outOfStock: outOfStock,
      );
    } catch (e) {
      throw Exception('Failed to get product stats: $e');
    }
  }

  Product _mapDocumentToProduct(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      businessId: data['businessId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      sku: data['sku'] ?? '',
      category: data['category'] ?? '',
      stock: data['stock'] ?? 0,
      minStock: data['minStock'] ?? 0,
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
