import 'package:flutter/material.dart';
import 'logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Dompet> dompetList = [
    Dompet(namaRekening: 'Dompet Utama', saldo: 100000.0),
    Dompet(namaRekening: 'Dompet Belanja', saldo: 50000.0),
  ];

  List<CatatanKeuangan> catatanList = [];

  // Fungsi untuk Menambah Dompet Baru
  void _tambahDompet() {
    TextEditingController namaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buat Dompet Baru'),
          content: TextField(
            controller: namaController,
            decoration: InputDecoration(hintText: 'Nama Rekening'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  dompetList.add(Dompet(namaRekening: namaController.text, saldo: 0.0));
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk Menambah Catatan Baru
  void _tambahCatatan() {
    TextEditingController jumlahController = TextEditingController();
    String kategori = 'Pemasukan';
    String? dompetTerpilih;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buat Catatan Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: kategori,
                onChanged: (value) {
                  setState(() {
                    kategori = value!;
                  });
                },
                items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: jumlahController,
                decoration: InputDecoration(hintText: 'Jumlah Uang'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: dompetTerpilih,
                onChanged: (value) {
                  setState(() {
                    dompetTerpilih = value;
                  });
                },
                hint: Text('Pilih Dompet'),
                items: dompetList.map((Dompet dompet) {
                  return DropdownMenuItem<String>(
                    value: dompet.namaRekening,
                    child: Text(dompet.namaRekening),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (dompetTerpilih != null && jumlahController.text.isNotEmpty) {
                  setState(() {
                    catatanList.add(CatatanKeuangan(
                      kategori: kategori,
                      jumlah: double.parse(jumlahController.text),
                      tanggal: DateTime.now(),
                      namaDompet: dompetTerpilih!,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Keuangan'),
      ),
      body: Column(
        children: [
          // Tampilkan Daftar Dompet
          Expanded(
            child: ListView.builder(
              itemCount: dompetList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dompetList[index].namaRekening),
                  subtitle: Text('Saldo: ${dompetList[index].saldo}'),
                );
              },
            ),
          ),
          // Tampilkan Daftar Catatan Keuangan
          Expanded(
            child: ListView.builder(
              itemCount: catatanList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${catatanList[index].kategori} - ${catatanList[index].jumlah}'),
                  subtitle: Text(
                      '${catatanList[index].namaDompet} - ${catatanList[index].tanggal.toLocal()}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _tambahCatatan,
            child: Icon(Icons.add),
            tooltip: 'Buat Catatan Baru',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _tambahDompet,
            child: Icon(Icons.account_balance_wallet),
            tooltip: 'Buat Dompet Baru',
          ),
        ],
      ),
    );
  }
}
