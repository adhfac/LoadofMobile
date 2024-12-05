import 'package:flutter/material.dart';

class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.blue
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'images/latian.jpg',
              ),
              const SizedBox(height: 20,),
              const Text('Mc Donalds 1999', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.deepPurple,
              ),),
              const SizedBox(height: 20,),
              Divider(color: Colors.grey,),
              const SizedBox(height: 10,),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Jika kode Anda masih menghasilkan error, kemungkinan ma-salahnya berkaitan dengan penggunaan const pada Material-App. Namun, kode yang Anda berikan tampak baik-baik saja dalam konteks umum. Untuk memastikan semuanya berfungsi dengan baik, saya akan memberikan kode lengkap yang bisa Anda gunakan. Berikut adalah contoh lengkap untuk aplikasi Flutter yang menampilkan AppBar dengan judul "Artikel App"',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
