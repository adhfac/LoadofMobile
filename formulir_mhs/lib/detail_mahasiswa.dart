import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'mahasiswa.dart';

class DetailMahasiswa extends StatelessWidget {
  final Mahasiswa mahasiswa;

  DetailMahasiswa({required this.mahasiswa});

  void _deleteMahasiswa(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Mahasiswa'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await DBHelper.instance.deleteMahasiswa(mahasiswa.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mahasiswa berhasil dihapus')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NPM: ${mahasiswa.npm}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Nama: ${mahasiswa.nama}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Umur: ${mahasiswa.umur}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deleteMahasiswa(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }
}
