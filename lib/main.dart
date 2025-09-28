import 'dart:io';

import 'package:belajar_provider/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

void main() async {
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting Firebase initialization...');
  print('Platform: ${Platform.operatingSystem}');

  try {
    if (Platform.isIOS) {
      try {
        await rootBundle.load('GoogleService-Info.plist');
        print('✅ GoogleService-Info.plist found');
      } catch (e) {
        print('❌ GoogleService-Info.plist NOT found: $e');
      }
    }

    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    print('App name: ${app.name}');
    print('Options: ${app.options}');
  } catch (e) {
    print('❌ Firebase initialization failed');
    print('Error: $e');
    print('Error type: ${e.runtimeType}');
  }

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> deleteByName(String name) async {
    // Query ke Firestore untuk cari dokumen dengan field "name"
    var snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: name)
        .get();

    // Loop semua hasil dan hapus
    for (var doc in snapshot.docs) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(doc.id)
          .delete();
      print("✅ Data dengan nama $name berhasil dihapus (ID: ${doc.id})");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TambahData(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            child: Text('Edit Data', style: TextStyle(color: Colors.white)),
          ),
        ],
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            var docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => deleteByName(docs[index]['name']),
                  child: ListTile(
                    title: Text(docs[index]['name']),
                    subtitle: Text(docs[index]['price'].toString()),
                    trailing: Text(docs[index]['stock'].toString()),
                    dense: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TambahData extends StatefulWidget {
  const TambahData({super.key});

  @override
  State<TambahData> createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _categoryProduct = TextEditingController();
    final TextEditingController _namaProduct = TextEditingController();
    final TextEditingController _hargaProduct = TextEditingController();
    final TextEditingController _stockProduct = TextEditingController();

    Future<void> addProduct() async {
      try {
        await FirebaseFirestore.instance.collection('products').add({
          'category': _categoryProduct.text.toString(),
          'name': _namaProduct.text.toString(),
          'price': int.tryParse(_hargaProduct.text),
          'stock': int.tryParse(_stockProduct.text),
          'created_at': FieldValue.serverTimestamp(),
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Berhasil di tambah kan',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Keluar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Tejadi kesalahan',
                style: TextStyle(color: Colors.black),
              ),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Keluar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('Tambah Data', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _namaProduct,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Nama produk',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: _hargaProduct,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Harga produk',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: _stockProduct,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Stok produk',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: _categoryProduct,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Categori produk',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: addProduct,
                child: Text('Tambah', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
