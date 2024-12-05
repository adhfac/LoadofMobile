import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'mahasiswa_list_page.dart';

void main() async {
  // Inisialisasi Hive
  await Hive.initFlutter();
  // Buka kotak untuk menyimpan data mahasiswa
  await Hive.openBox('mahasiswaBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MahasiswaListPage(),
    );
  }
}
