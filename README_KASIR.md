# Aplikasi Kasir SMK Bani Ma'sum

## Deskripsi
Aplikasi kasir modern untuk SMK Bani Ma'sum dengan desain hitam putih bercahaya yang elegan. Aplikasi ini dirancang khusus untuk kebutuhan bengkel sekolah dengan fitur lengkap untuk manajemen penjualan dan inventori.

## Fitur Utama

### 1. **Tampilan Kasir**
- Desain hitam putih bercahaya yang modern
- Layout split-screen (70% produk, 30% keranjang)
- Grid produk dengan kategori filter
- Pencarian produk real-time
- Indikator stok tersedia

### 2. **Manajemen Keranjang**
- Tambah barang ke cart dengan satu klik
- Update quantity langsung dari cart
- Hapus item dari cart
- Total harga otomatis
- Indikator jumlah item di cart

### 3. **Pembayaran**
- Input uang cash dengan validasi
- Perhitungan kembalian otomatis
- Tombol uang pas cepat
- Validasi uang kurang
- Proses pembayaran aman

### 4. **Struk Transaksi**
- Tampilan struk profesional
- Informasi lengkap transaksi
- ID transaksi unik
- Detail item pembelian
- Total, tunai, dan kembali

### 5. **Manajemen Barang**
- Tambah barang baru
- Edit informasi barang
- Hapus barang
- Cari barang
- Tampilan stok real-time

### 6. **Database Firestore**
- Penyimpanan data barang
- Riwayat transaksi
- Update stok otomatis
- Sinkronisasi real-time

## Struktur Aplikasi

```
lib/
├── models/
│   ├── product.dart          # Model data barang
│   └── transaction.dart      # Model data transaksi
├── providers/
│   └── cart_provider.dart    # State management keranjang
├── services/
│   └── firestore_service.dart # Layanan database
├── screens/
│   ├── cashier_screen.dart   # Halaman utama kasir
│   ├── payment_screen.dart   # Halaman pembayaran
│   ├── receipt_screen.dart   # Halaman struk
│   └── product_management_screen.dart # Manajemen barang
├── firebase_options.dart     # Konfigurasi Firebase
└── main.dart                 # Entry point aplikasi
```

## Teknologi yang Digunakan

- **Flutter**: Framework UI cross-platform
- **Provider**: State management
- **Firebase Firestore**: Database NoSQL real-time
- **Dart**: Bahasa pemrograman

## Cara Penggunaan

### 1. Menambah Barang ke Cart
- Klik pada produk yang diinginkan
- Jumlah akan otomatis bertambah jika sudah ada di cart
- Lihat keranjang di sisi kanan

### 2. Proses Pembayaran
- Klik tombol "BAYAR" di keranjang
- Masukkan jumlah uang cash
- Lihat perhitungan kembalian
- Klik "PROSES PEMBAYARAN"

### 3. Manajemen Barang
- Klik menu "BARANG" di bottom navigation
- Tambah: Klik tombol "+" atau "TAMBAH BARANG"
- Edit: Klik ikon edit pada barang
- Hapus: Klik ikon delete pada barang

### 4. Melihat Struk
- Setelah pembayaran berhasil, struk akan tampil
- Klik "CETAK STRUK" untuk mencetak
- Klik "TRANSAKSI BARU" untuk kembali ke kasir

## Desain Visual

### Warna Utama
- **Hitam**: Background utama (#000000)
- **Putih**: Teks dan elemen utama (#FFFFFF)
- **Abu-abu**: Elemen sekunder (variasi #808080)

### Efek Visual
- **Glow effect**: Bayangan putih transparan
- **Rounded corners**: Sudut melengkung 10-25px
- **Shadow**: Efek kedalaman pada card
- **Typography**: Font bold untuk header, regular untuk body

## Keamanan & Validasi

- Validasi input uang cash
- Validasi stok barang
- Konfirmasi hapus data
- Error handling pada database
- Transaction ID unik

## Instalasi

1. Clone repository
2. Jalankan `flutter pub get`
3. Konfigurasi Firebase (sudah terintegrasi)
4. Jalankan `flutter run`

## Fitur yang Akan Datang

- Cetak struk ke printer thermal
- Laporan penjualan harian/bulanan
- Manajemen user/login
- Export data ke Excel
- Mode offline

## Kontak

SMK Bani Ma'sum
- Email: info@smkbanimasum.sch.id
- Telepon: (021) 1234-5678

---

*Aplikasi ini dikembangkan khusus untuk SMK Bani Ma'sum untuk meningkatkan efisiensi sistem kasir bengkel sekolah.*