import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutProductManagementScreen extends StatelessWidget {
  const AboutProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'TENTANG MANAJEMEN BARANG',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'MANAJEMEN BARANG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.blue,
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              'Fitur Lengkap Pengelolaan Inventori',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 24),
            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Fitur:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manajemen barang adalah fitur inti dalam aplikasi kasir ini yang memungkinkan '
                    'pengguna untuk mengelola inventori produk dengan mudah dan efisien. '
                    'Fitur ini mendukung operasi CRUD (Create, Read, Update, Delete) lengkap '
                    'untuk mengelola data barang secara real-time.',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Features List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fitur Utama Manajemen Barang:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.add_circle,
                    'Tambah Barang Baru',
                    'Menambahkan produk baru dengan informasi lengkap seperti nama, harga, dan stok',
                  ),
                  _buildFeatureItem(
                    Icons.edit,
                    'Edit Data Barang',
                    'Mengubah informasi barang yang sudah ada seperti harga, nama, atau jumlah stok',
                  ),
                  _buildFeatureItem(
                    Icons.delete,
                    'Hapus Barang',
                    'Menghapus barang dari database dengan konfirmasi keamanan',
                  ),
                  _buildFeatureItem(
                    Icons.search,
                    'Pencarian Cepat',
                    'Mencari barang berdasarkan nama dengan fitur search real-time',
                  ),
                  _buildFeatureItem(
                    Icons.sort,
                    'Pengurutan Data',
                    'Mengurutkan daftar barang berdasarkan nama atau harga',
                  ),
                  _buildFeatureItem(
                    Icons.update,
                    'Update Stok Real-time',
                    'Stok barang otomatis terupdate saat terjadi transaksi penjualan',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Data Fields
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Data Barang:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDataField('Nama Barang', 'Nama produk yang dijual'),
                  _buildDataField(
                    'Harga Jual',
                    'Harga satuan barang dalam Rupiah',
                  ),
                  _buildDataField(
                    'Stok Tersedia',
                    'Jumlah barang yang tersedia di gudang',
                  ),
                  _buildDataField('Kategori', 'Klasifikasi barang (opsional)'),
                  _buildDataField(
                    'Kode Barang',
                    'Kode unik untuk identifikasi barang',
                  ),
                  _buildDataField(
                    'Deskripsi',
                    'Penjelasan detail tentang barang',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Technology Integration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Integrasi Teknologi:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTechItem(
                    Icons.cloud_done,
                    'Firebase Firestore',
                    'Penyimpanan data real-time di cloud dengan sinkronisasi otomatis',
                  ),
                  _buildTechItem(
                    Icons.sync,
                    'Auto-sync',
                    'Data otomatis tersinkronisasi antar perangkat dalam waktu real-time',
                  ),
                  _buildTechItem(
                    Icons.security,
                    'Keamanan Data',
                    'Data terlindungi dengan autentikasi dan enkripsi Firebase',
                  ),
                  _buildTechItem(
                    Icons.offline_bolt,
                    'Offline Support',
                    'Aplikasi tetap berfungsi offline dan sync saat koneksi tersedia',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Benefits
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keuntungan Penggunaan:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    'Efisiensi Operasional',
                    'Mengurangi waktu pengelolaan inventori secara manual',
                  ),
                  _buildBenefitItem(
                    'Akurasi Data',
                    'Minimalkan kesalahan input data barang',
                  ),
                  _buildBenefitItem(
                    'Kontrol Stok Real-time',
                    'Selalu tahu jumlah stok yang tersedia',
                  ),
                  _buildBenefitItem(
                    'Analisis Penjualan',
                    'Mudah melacak barang yang paling laris',
                  ),
                  _buildBenefitItem(
                    'Akses Multi-perangkat',
                    'Data bisa diakses dari berbagai perangkat',
                  ),
                  _buildBenefitItem(
                    'Backup Otomatis',
                    'Data aman di cloud tanpa perlu backup manual',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Usage Tips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips Penggunaan:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    'Pastikan data barang lengkap saat menambahkan produk baru',
                  ),
                  _buildTipItem(
                    'Update stok secara berkala untuk menjaga akurasi data',
                  ),
                  _buildTipItem(
                    'Gunakan fitur pencarian untuk menemukan barang dengan cepat',
                  ),
                  _buildTipItem(
                    'Hapus barang yang sudah tidak dijual untuk menjaga kebersihan data',
                  ),
                  _buildTipItem(
                    'Monitor stok rendah untuk pengadaan barang yang tepat waktu',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Footer
            Text(
              'Fitur ini dikembangkan untuk mempermudah pengelolaan inventori\n'
              'di bengkel sekolah SMK Bani Ma\'sum',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Back Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'KEMBALI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[400], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataField(String field, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Colors.green[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(IconData icon, String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple[400], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Colors.orange[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 10),
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
