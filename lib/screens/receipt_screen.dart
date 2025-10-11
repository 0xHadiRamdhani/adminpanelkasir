import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/firestore_service.dart';

class ReceiptScreen extends StatefulWidget {
  final String transactionId;
  final int totalAmount;
  final int cashAmount;
  final int changeAmount;

  const ReceiptScreen({
    super.key,
    required this.transactionId,
    required this.totalAmount,
    required this.cashAmount,
    required this.changeAmount,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Transaction? _transaction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    try {
      final transaction = await _firestoreService.getTransaction(
        widget.transactionId,
      );
      if (mounted) {
        setState(() {
          _transaction = transaction;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transaction: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'TRANSAKSI BERHASIL',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout untuk Android
          if (constraints.maxWidth < 600) {
            // Layout mobile - vertical - proporsi lebih kecil untuk action buttons
            return Column(
              children: [
                // Receipt Preview Section
                Expanded(flex: 7, child: _buildReceiptPreview()),
                // Action Buttons Section - proporsi lebih kecil
                Expanded(flex: 3, child: _buildActionButtons()),
              ],
            );
          } else {
            // Layout tablet/desktop - horizontal
            return Row(
              children: [
                // Receipt Preview Section (60% width)
                Expanded(flex: 6, child: _buildReceiptPreview()),
                // Action Buttons Section (40% width)
                Expanded(flex: 4, child: _buildActionButtons()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildReceiptPreview() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Receipt Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Center(
              child: Text(
                'SMK BANI MA\'SUM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          // Receipt Content
          Expanded(
            child: Builder(
              builder: (context) {
                final items = _transaction?.items ?? [];
                final receipt = Receipt(
                  transactionId: widget.transactionId,
                  schoolName: 'SMK BANI MA\'SUM',
                  address: 'Jl. Raya Cimanggu, Kec. Cisalak, Kab. Subang',
                  phone: ' yayasanbanimasum@gmail.com',
                  date: _transaction?.transactionDate ?? DateTime.now(),
                  items: items,
                  subtotal: widget.totalAmount,
                  total: widget.totalAmount,
                  cash: widget.cashAmount,
                  change: widget.changeAmount,
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // School Info
                      Center(
                        child: Column(
                          children: [
                            Text(
                              receipt.schoolName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(receipt.address),
                            Text(receipt.phone),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 2),
                      const SizedBox(height: 8),
                      // Transaction Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tanggal: ${receipt.date.day}/${receipt.date.month}/${receipt.date.year}',
                          ),
                          Text(
                            '${receipt.date.hour}:${receipt.date.minute.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                      Text('ID: ${receipt.transactionId}'),
                      const SizedBox(height: 8),
                      const Divider(thickness: 2),
                      const SizedBox(height: 8),
                      // Items
                      const Text(
                        'ITEM PEMBELIAN:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '  ${item.quantity} x ${_formatRupiah(item.product.price)}',
                                      ),
                                      Text(_formatRupiah(item.totalPrice)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 8),
                      const Divider(thickness: 2),
                      const SizedBox(height: 8),
                      // Total Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatRupiah(receipt.subtotal),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatRupiah(receipt.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
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
                            'Tunai',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatRupiah(receipt.cash),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kembali',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _formatRupiah(receipt.change),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 2),
                      const SizedBox(height: 8),
                      // Footer
                      const Center(
                        child: Text(
                          'TERIMA KASIH',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Center(child: Text('SMK BANI MA\'SUM')),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon - ukuran lebih kecil
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'TRANSAKSI BERHASIL!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${widget.transactionId}',
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
            ),
            const SizedBox(height: 12),
            // Transaction Summary - super compact
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                      Text(
                        _formatRupiah(widget.totalAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tunai',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                      Text(
                        _formatRupiah(widget.cashAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kembali',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                      Text(
                        _formatRupiah(widget.changeAmount),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Action Buttons - super compact
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  _printReceipt();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print, color: Colors.black, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'CETAK STRUK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'TRANSAKSI BARU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printReceipt() {
    // For now, we'll show a snackbar as printing functionality
    // would require platform-specific implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur cetak struk akan segera tersedia'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
