import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);  // Kembali ke halaman sebelumnya
          },
          child: Text('Back to Home'),
        ),
      ),
    );
  }
}