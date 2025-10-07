import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalItems => _cartItems.length;

  int get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Product product) {
    // Check if product already exists in cart
    int existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // If exists, increase quantity
      _cartItems[existingIndex].quantity++;
    } else {
      // If not exists, add new item
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    int index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    int index = _cartItems.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _cartItems[index].quantity : 0;
  }
}
