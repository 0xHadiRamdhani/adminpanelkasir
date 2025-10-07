class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.createdAt,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      stock: (data['stock'] ?? 0).toInt(),
      createdAt: data['created_at']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'created_at': createdAt ?? DateTime.now(),
    };
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get totalPrice => product.price * quantity;
}
