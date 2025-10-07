# Kasir SMK Bani Ma'sum

A new Flutter project.

## 📱 Fitur Utama

### 💰 Sistem Kasir
- **Penjualan Barang**: Tambah barang ke keranjang dengan mudah
- **Pembayaran Tunai**: Input uang cash dengan perhitungan otomatis
- **Perhitungan Kembalian**: Hitung kembalian secara real-time
- **Tombol Uang Pas**: Cepat untuk jumlah yang tepat

### 🧾 Cetak Struk
- **Struk Lengkap**: Informasi sekolah, tanggal, ID transaksi
- **Detail Item**: Nama barang, quantity, harga satuan, total
- **Ringkasan Transaksi**: Subtotal, total, tunai, kembalian

### 📦 Manajemen Barang
- **CRUD Lengkap**: Tambah, edit, hapus barang
- **Pencarian**: Cari barang berdasarkan nama
- **Filter Kategori**: Oli, Ban, Aki, Sparepart, Lainnya
- **Stok Management**: Update stok otomatis setelah transaksi

### 📊 Riwayat Transaksi
- **50 Transaksi Terakhir**: Tampilkan dengan detail lengkap
- **Detail Transaksi**: Items, total, kasir, waktu transaksi
- **Pencarian**: Cari transaksi berdasarkan ID

### ℹ️ About App
- **Developer Info**: Hadi Ramdhani - Programmer & Developer
- **Portfolio**: Link ke https://hadiramdhanii.web.app
- **Teknologi**: Flutter, Firebase, Provider, Dart
- **Versi**: 1.0.0

## 🎨 Desain

### Tema Hitam Putih Bercahaya
- **Warna Dominan**: Hitam dengan aksen putih
- **Efek Cahaya**: Shadow dan glow effect
- **Modern UI**: Clean dan professional
- **Responsive**: Support mobile dan tablet

### Layout Responsive
- **Mobile (< 600px)**: Layout vertikal
- **Tablet/Desktop (> 600px)**: Layout horizontal
- **Adaptive**: Menyesuaikan ukuran layar

## 🚀 Teknologi

| Teknologi | Kegunaan |
|-----------|----------|
| **Flutter** | Framework UI cross-platform |
| **Firebase Firestore** | Database real-time |
| **Provider** | State management |
| **Dart** | Bahasa pemrograman |
| **url_launcher** | Membuka link portfolio |

## 📁 Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── firebase_options.dart     # Konfigurasi Firebase
├── models/
│   ├── product.dart         # Model data barang
│   └── transaction.dart     # Model data transaksi
├── providers/
│   └── cart_provider.dart   # State management keranjang
├── services/
│   └── firestore_service.dart # Service Firebase Firestore
└── screens/
    ├── cashier_screen.dart      # Halaman utama kasir
    ├── payment_screen.dart      # Halaman pembayaran
    ├── receipt_screen.dart      # Halaman struk
    ├── product_management_screen.dart # Manajemen barang
    ├── transaction_history_screen.dart # Riwayat transaksi
    └── about_screen.dart        # Tentang aplikasi
```

## 🛠️ Instalasi

### Prasyarat
- Flutter SDK ^3.9.2
- Dart SDK
- Android Studio / VS Code
- Firebase Account

### Langkah Instalasi

1. **Clone Repository**
```bash
git clone https://github.com/username/kasir-smk-bani-masum.git
cd kasir-smk-bani-masum
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Konfigurasi Firebase**
- Buat project di Firebase Console
- Download `google-services.json` untuk Android
- Download `GoogleService-Info.plist` untuk iOS
- Letakkan file tersebut di folder yang sesuai

4. **Jalankan Aplikasi**
```bash
flutter run
```

## 🔧 Konfigurasi

### Firebase Setup
1. Aktifkan **Firestore Database**
2. Buat collection `products` dengan field:
   - `name` (string)
   - `category` (string)
   - `price` (number)
   - `stock` (number)
   - `created_at` (timestamp)

3. Buat collection `transactions` dengan field:
   - `items` (array)
   - `totalAmount` (number)
   - `cashAmount` (number)
   - `changeAmount` (number)
   - `transactionDate` (timestamp)
   - `cashierName` (string)

### Firestore Indexes
Untuk query yang optimal, buat composite index di Firebase Console untuk:
- Collection: `products`
- Fields: `category` (Ascending), `name` (Ascending)

## 📱 Cara Penggunaan

### 1. Transaksi Penjualan
1. Pilih barang dari grid produk
2. Atur jumlah di keranjang
3. Klik tombol **BAYAR**
4. Masukkan jumlah uang
5. Klik **PROSES**
6. Lihat struk transaksi

### 2. Manajemen Barang
1. Klik ikon manajemen di app bar
2. Tambah barang baru dengan tombol **+**
3. Edit barang dengan ikon pensil
4. Hapus barang dengan ikon sampah

### 3. Lihat Riwayat
1. Klik ikon riwayat transaksi
2. Lihat daftar transaksi terakhir
3. Klik transaksi untuk detail lengkap

### 4. About App
1. Klik ikon info di app bar
2. Lihat informasi aplikasi
3. Klik **BUKA PORTFOLIO HADI RAMDHANI** untuk membuka web portfolio

## 🎯 Developer

**Hadi Ramdhani**
- **Role**: Programmer & Developer
- **Specialization**: Full Stack Developer
- **Portfolio**: [https://hadiramdhanii.web.app](https://hadiramdhanii.web.app)
- **Email**: hadiramdhani09@gmail.com

## 📄 Lisensi

```
Copyright © 2024 SMK Bani Ma'sum
All Rights Reserved

Aplikasi ini dikembangkan untuk keperluan sekolah SMK Bani Ma'sum
dan tidak untuk distribusi komersial tanpa izin tertulis.
```

## 🙏 Ucapan Terima Kasih

Terima kasih kepada:
- **SMK Bani Ma'sum** untuk kepercayaannya
- **Flutter Community** untuk support dan dokumentasi
- **Firebase Team** untuk platform database yang handal

---

**Made with ❤️ by Hadi Ramdhani**
