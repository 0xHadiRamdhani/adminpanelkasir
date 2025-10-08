import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/transaction.dart';

class RealtimeListenerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listeners untuk produk
  StreamSubscription<QuerySnapshot>? _productsListener;
  DateTime? _lastProductCheckTime;

  // Listeners untuk transaksi
  StreamSubscription<QuerySnapshot>? _transactionsListener;
  DateTime? _lastTransactionCheckTime;

  // Callback untuk notifikasi
  Function(String, String)? onProductNotification;
  Function(String, String)? onTransactionNotification;

  void initializeListeners({
    Function(String, String)? onProductAdded,
    Function(String, String)? onNewTransaction,
  }) {
    onProductNotification = onProductAdded;
    onTransactionNotification = onNewTransaction;

    // Set waktu awal untuk menghindari notifikasi saat pertama kali load
    _lastProductCheckTime = DateTime.now();
    _lastTransactionCheckTime = DateTime.now();

    // Start listening to products
    _listenToProducts();

    // Start listening to transactions
    _listenToTransactions();
  }

  void _listenToProducts() {
    _productsListener = _firestore
        .collection('products')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            // Skip notifikasi untuk data awal
            if (_lastProductCheckTime == null) return;

            // Cek dokumen baru yang dibuat setelah waktu check terakhir
            for (var docChange in snapshot.docChanges) {
              if (docChange.type == DocumentChangeType.added) {
                var data = docChange.doc.data();
                if (data != null && data['created_at'] != null) {
                  DateTime createdAt = (data['created_at'] as Timestamp)
                      .toDate();

                  // Hanya notifikasi jika produk dibuat setelah waktu check terakhir
                  if (createdAt.isAfter(_lastProductCheckTime!)) {
                    String productName = data['name'] ?? 'Produk Baru';
                    String message = 'Produk baru ditambahkan: $productName';

                    if (onProductNotification != null) {
                      onProductNotification!('Produk Baru', message);
                    }
                  }
                }
              }
            }
          },
          onError: (error) {
            print('Error listening to products: $error');
          },
        );
  }

  void _listenToTransactions() {
    _transactionsListener = _firestore
        .collection('transactions')
        .orderBy('transactionDate', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            // Skip notifikasi untuk data awal
            if (_lastTransactionCheckTime == null) return;

            // Cek dokumen baru yang dibuat setelah waktu check terakhir
            for (var docChange in snapshot.docChanges) {
              if (docChange.type == DocumentChangeType.added) {
                var data = docChange.doc.data();
                if (data != null && data['transactionDate'] != null) {
                  DateTime transactionDate =
                      (data['transactionDate'] as Timestamp).toDate();

                  // Hanya notifikasi jika transaksi dibuat setelah waktu check terakhir
                  if (transactionDate.isAfter(_lastTransactionCheckTime!)) {
                    String transactionId = docChange.doc.id;
                    double totalAmount = (data['totalAmount'] ?? 0).toDouble();
                    String message =
                        'Transaksi baru dari perangkat lain: Rp ${totalAmount.toStringAsFixed(0)}';

                    if (onTransactionNotification != null) {
                      onTransactionNotification!('Transaksi Baru', message);
                    }
                  }
                }
              }
            }
          },
          onError: (error) {
            print('Error listening to transactions: $error');
          },
        );
  }

  void dispose() {
    _productsListener?.cancel();
    _transactionsListener?.cancel();
  }

  // Method untuk reset waktu check (berguna saat user kembali ke app)
  void resetCheckTimes() {
    _lastProductCheckTime = DateTime.now();
    _lastTransactionCheckTime = DateTime.now();
  }
}
