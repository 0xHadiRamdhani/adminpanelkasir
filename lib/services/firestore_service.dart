import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/product.dart';
import '../models/transaction.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Product-related methods
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add(product.toFirestore());
  }

  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  Future<void> updateStock(String productId, int newStock) async {
    await _firestore.collection('products').doc(productId).update({
      'stock': newStock.toInt(),
    });
  }

  // Transaction-related methods
  Future<String> createTransaction(Transaction transaction) async {
    DocumentReference docRef = await _firestore
        .collection('transactions')
        .add(transaction.toFirestore());
    return docRef.id;
  }

  Stream<List<Transaction>> getTransactions({int limit = 50}) {
    return _firestore
        .collection('transactions')
        .orderBy('transactionDate', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Transaction.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get single transaction by ID
  Future<Transaction?> getTransaction(String transactionId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('transactions')
          .doc(transactionId)
          .get();

      if (doc.exists) {
        return Transaction.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Search products
  Stream<List<Product>> searchProducts(String query) {
    return _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
