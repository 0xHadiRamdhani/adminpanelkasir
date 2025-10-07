import 'product.dart';

class Transaction {
  final String id;
  final List<CartItem> items;
  final int totalAmount;
  final int cashAmount;
  final int changeAmount;
  final DateTime transactionDate;
  final String cashierName;

  Transaction({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.cashAmount,
    required this.changeAmount,
    required this.transactionDate,
    required this.cashierName,
  });

  factory Transaction.fromFirestore(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      items:
          (data['items'] as List<dynamic>?)
              ?.map(
                (item) => CartItem(
                  product: Product.fromFirestore(
                    item['product'],
                    item['product']['id'],
                  ),
                  quantity: item['quantity'] ?? 1,
                ),
              )
              .toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0).toInt(),
      cashAmount: (data['cashAmount'] ?? 0).toInt(),
      changeAmount: (data['changeAmount'] ?? 0).toInt(),
      transactionDate: data['transactionDate']?.toDate() ?? DateTime.now(),
      cashierName: data['cashierName'] ?? 'Kasir',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'items': items
          .map(
            (item) => {
              'product': item.product.toFirestore()..['id'] = item.product.id,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'totalAmount': totalAmount,
      'cashAmount': cashAmount,
      'changeAmount': changeAmount,
      'transactionDate': transactionDate,
      'cashierName': cashierName,
    };
  }
}

class Receipt {
  final String transactionId;
  final String schoolName;
  final String address;
  final String phone;
  final DateTime date;
  final List<CartItem> items;
  final int subtotal;
  final int total;
  final int cash;
  final int change;

  Receipt({
    required this.transactionId,
    required this.schoolName,
    required this.address,
    required this.phone,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.total,
    required this.cash,
    required this.change,
  });

  String generateReceiptText() {
    StringBuffer receipt = StringBuffer();

    receipt.writeln('=== SMK BANI MA\'SUM ===');
    receipt.writeln('$schoolName');
    receipt.writeln('$address');
    receipt.writeln('Telp: $phone');
    receipt.writeln('========================');
    receipt.writeln(
      'Tanggal: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
    );
    receipt.writeln('ID Transaksi: $transactionId');
    receipt.writeln('========================');

    for (var item in items) {
      receipt.writeln('${item.product.name}');
      receipt.writeln(
        '  ${item.quantity} x ${formatRupiah(item.product.price)} = ${formatRupiah(item.totalPrice)}',
      );
    }

    receipt.writeln('========================');
    receipt.writeln('Subtotal: ${formatRupiah(subtotal)}');
    receipt.writeln('Total: ${formatRupiah(total)}');
    receipt.writeln('Tunai: ${formatRupiah(cash)}');
    receipt.writeln('Kembali: ${formatRupiah(change)}');
    receipt.writeln('========================');
    receipt.writeln('Terima Kasih');
    receipt.writeln('SMK BANI MA\'SUM');

    return receipt.toString();
  }

  String formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
