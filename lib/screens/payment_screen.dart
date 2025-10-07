import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import 'receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _cashController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'PEMBAYARAN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout untuk Android
          if (constraints.maxWidth < 600) {
            // Layout mobile - vertical
            return Column(
              children: [
                // Order Summary Section
                Expanded(flex: 4, child: _buildOrderSummary()),
                // Payment Input Section - menggunakan Expanded untuk fleksibilitas
                Expanded(flex: 6, child: _buildPaymentInput()),
              ],
            );
          } else {
            // Layout tablet/desktop - horizontal
            return Row(
              children: [
                // Order Summary Section (60% width)
                Expanded(flex: 6, child: _buildOrderSummary()),
                // Payment Input Section (40% width)
                Expanded(flex: 4, child: _buildPaymentInput()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RINGKASAN PEMBELIAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.receipt_long, color: Colors.white, size: 24),
              ],
            ),
          ),
          // Items List
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cart.cartItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.quantity} x ${_formatRupiah(item.product.price)}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatRupiah(item.totalPrice),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Total Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatRupiah(cart.totalAmount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatRupiah(cart.totalAmount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInput() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Payment Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.payment, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'PEMBAYARAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Payment Content - versi compact untuk mobile dengan scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Uang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan jumlah uang',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      prefixText: 'Rp ',
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  // Quick Cash Buttons
                  const Text(
                    'Uang Pas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final buttonWidth = (constraints.maxWidth - 8) / 3;
                          return Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              _buildQuickCashButton(
                                cart.totalAmount,
                                buttonWidth,
                              ),
                              _buildQuickCashButton(
                                cart.totalAmount + 5000,
                                buttonWidth,
                              ),
                              _buildQuickCashButton(
                                cart.totalAmount + 10000,
                                buttonWidth,
                              ),
                              _buildQuickCashButton(
                                cart.totalAmount + 20000,
                                buttonWidth,
                              ),
                              _buildQuickCashButton(50000, buttonWidth),
                              _buildQuickCashButton(100000, buttonWidth),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Change Calculation
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      final cash =
                          (double.tryParse(_cashController.text) ?? 0.0)
                              .toInt();
                      final change = cash - cart.totalAmount;

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: change >= 0 ? Colors.green : Colors.red,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  change >= 0 ? _formatRupiah(change) : 'Rp 0',
                                  style: TextStyle(
                                    color: change >= 0
                                        ? Colors.green[400]
                                        : Colors.red[400],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (change < 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Uang kurang: ${_formatRupiah(-change)}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Process Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        final cash =
                            (double.tryParse(_cashController.text) ?? 0.0)
                                .toInt();
                        final isValid =
                            cash >= cart.totalAmount && cart.totalAmount > 0;

                        return ElevatedButton(
                          onPressed: isValid && !_isProcessing
                              ? () => _processPayment()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isValid
                                ? Colors.white
                                : Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isProcessing
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'PROSES',
                                  style: TextStyle(
                                    color: isValid
                                        ? Colors.black
                                        : Colors.grey[500],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCashButton(int amount, [double? width]) {
    return GestureDetector(
      onTap: () {
        _cashController.text = amount.toString();
        setState(() {});
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Text(
          _formatRupiah(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final cash = (double.tryParse(_cashController.text) ?? 0.0).toInt();
      final change = cash - cart.totalAmount;

      // Create transaction
      final transaction = Transaction(
        id: '',
        items: List.from(cart.cartItems),
        totalAmount: cart.totalAmount,
        cashAmount: cash,
        changeAmount: change,
        transactionDate: DateTime.now(),
        cashierName: 'Kasir SMK Bani Ma\'sum',
      );

      // Save to Firestore
      final transactionId = await _firestoreService.createTransaction(
        transaction,
      );

      // Update product stock
      for (var item in cart.cartItems) {
        final newStock = item.product.stock - item.quantity;
        await _firestoreService.updateStock(item.product.id, newStock);
      }

      // Clear cart
      cart.clearCart();

      // Navigate to receipt screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(
              transactionId: transactionId,
              totalAmount: transaction.totalAmount,
              cashAmount: transaction.cashAmount,
              changeAmount: transaction.changeAmount,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
