import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'mahasiswa.dart';

class TambahMahasiswa extends StatelessWidget {
  final VoidCallback refreshList;

  TambahMahasiswa({required this.refreshList});

  final _formKey = GlobalKey<FormState>();
  final _npmController = TextEditingController();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();

  void _saveData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final mahasiswa = Mahasiswa(
        npm: _npmController.text,
        nama: _namaController.text,
        umur: int.parse(_umurController.text),
      );
      await DBHelper.instance.addMahasiswa(mahasiswa);
      refreshList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _npmController,
                decoration: InputDecoration(labelText: 'NPM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NPM harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _umurController,
                decoration: InputDecoration(labelText: 'Umur'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Umur harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveData(context),
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
