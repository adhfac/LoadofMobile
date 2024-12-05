import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'mahasiswa.dart';
import 'tambah_mahasiswa.dart';
import 'detail_mahasiswa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarMahasiswa(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DaftarMahasiswa extends StatefulWidget {
  @override
  _DaftarMahasiswaState createState() => _DaftarMahasiswaState();
}

class _DaftarMahasiswaState extends State<DaftarMahasiswa> {
  late Future<List<Mahasiswa>> _mahasiswaList;

  @override
  void initState() {
    super.initState();
    _refreshList(); // Memuat data saat pertama kali aplikasi dibuka
  }

  void _refreshList() {
    setState(() {
      _mahasiswaList = DBHelper.instance.getMahasiswaList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Mahasiswa'),
      ),
      body: FutureBuilder(
        future: _mahasiswaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('Belum ada data mahasiswa.'));
          } else {
            final mahasiswaList = snapshot.data as List<Mahasiswa>;
            return ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final mahasiswa = mahasiswaList[index];
                return ListTile(
                  title: Text(mahasiswa.nama),
                  subtitle: Text('NPM: ${mahasiswa.npm} - Umur: ${mahasiswa.umur}'),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailMahasiswa(mahasiswa: mahasiswa),
                        ),
                      ).then((_) => _refreshList()); // Refresh saat kembali
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahMahasiswa(refreshList: _refreshList),
            ),
          ).then((_) => _refreshList()); // Refresh setelah menambah data
        },
      ),
    );
  }
}
