import 'package:flutter/material.dart';
import 'package:logkeu/db_helper.dart';
import 'package:logkeu/models/dompet.dart';
import 'package:logkeu/models/pemasukan.dart';
import 'package:logkeu/models/pengeluaran.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Dompet>> _dompetList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _dompetList = DBHelper.getDompetList();
    });
  }

  final List<String> _quotes = [
    "Hemat pangkal kaya.",
    "Uangmu mencerminkan prioritasmu.",
    "Menabung sekarang, menikmati kemudian.",
    "Masa depan dimulai dari keuangan yang sehat.",
    "Jangan habiskan semua pendapatanmu, sisakan untuk dirimu di masa depan.",
  ];

  String _getTodayQuote() {
    int todayIndex = DateTime.now().day % _quotes.length;
    return _quotes[todayIndex];
  }

  String formatUang(double amount) {
    String result = amount.toStringAsFixed(2);

    List<String> parts = result.split(".");
    String integerPart = parts[0];
    String decimalPart = parts[1];

    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (match) => ".");
    return "Rp $integerPart,$decimalPart";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Dompet',
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      body: FutureBuilder(
        future: _dompetList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(
                child: Text('Belum ada data dompet',
                    style: TextStyle(fontFamily: 'Lato')));
          } else {
            final dompetList = snapshot.data as List<Dompet>;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: dompetList.length,
                    itemBuilder: (context, index) {
                      final dompet = dompetList[index];
                      return ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text(dompet.namaDompet,
                            style: TextStyle(fontFamily: 'Lato')),
                        subtitle: Text(
                            'Saldo: ${formatUang(dompet.jumlahUang)}',
                            style: const TextStyle(fontFamily: 'Lato')),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailDompet(dompet: dompet),
                              ),
                            ).then((_) => _refreshList());
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _getTodayQuote(),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add_box_rounded),
            onPressed: () async {
              final dompetList = await _dompetList;
              if (dompetList.length >= 10) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Batas Dompet Tercapai',
                        style: TextStyle(
                          fontFamily: 'Lato',
                        ),
                      ),
                      content: const Text(
                        'Anda sudah mencapai batas maksimal 10 dompet',
                        style: TextStyle(
                          fontFamily: 'Lato',
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            'Tutup',
                            style: TextStyle(fontFamily: 'Lato'),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TambahDompet(refreshList: _refreshList),
                  ),
                ).then((_) => _refreshList());
              }
            },
          );
        },
      ),
    );
  }
}

class DetailDompet extends StatefulWidget {
  final Dompet dompet;
  const DetailDompet({required this.dompet});

  @override
  State<DetailDompet> createState() => _DetailDompetState();
}

class _DetailDompetState extends State<DetailDompet> {
  late Future<List<Map<String, dynamic>>> _pemasukanList;
  late Future<List<Map<String, dynamic>>> _pengeluaranList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _pemasukanList = DBHelper.getPemasukanByDompet(widget.dompet.idDompet!);
      _pengeluaranList =
          DBHelper.getPengeluaranByDompet(widget.dompet.idDompet!);
    });
  }

  String formatUang(double amount) {
    String result = amount.toStringAsFixed(2);

    List<String> parts = result.split(".");
    String integerPart = parts[0];
    String decimalPart = parts[1];

    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (match) => ".");

    return "Rp $integerPart,$decimalPart";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dompet.namaDompet,
            style: TextStyle(fontFamily: 'Lato')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Dompet: ${widget.dompet.namaDompet}',
              style: TextStyle(fontFamily: 'Lato'),
            ),
            const SizedBox(height: 8),
            Text(
              'Saldo: ${formatUang(widget.dompet.jumlahUang)}',
              style: TextStyle(fontFamily: 'Lato'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToTambahPemasukan(context),
                  child: Text('Tambah Pemasukan'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToTambahPengeluaran(context),
                  child: Text('Tambah Pengeluaran'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([_pemasukanList, _pengeluaranList]),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final pemasukanList =
                        snapshot.data[0] as List<Map<String, dynamic>>;
                    final pengeluaranList =
                        snapshot.data[1] as List<Map<String, dynamic>>;

                    return ListView(
                      children: [
                        // Pemasukan list
                        ...pemasukanList.map((data) {
                          final pemasukan = Pemasukan.fromMap(data);
                          return ListTile(
                            leading:
                                Icon(Icons.arrow_downward, color: Colors.green),
                            title: Text(pemasukan.judul),
                            subtitle: Text(formatUang(pemasukan.jumlahUang)),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _deletePemasukan(pemasukan.idPemasukan!);
                              },
                            ),
                          );
                        }).toList(),
                        // Pengeluaran list
                        ...pengeluaranList.map((data) {
                          final pengeluaran = Pengeluaran.fromMap(data);
                          return ListTile(
                            leading:
                                Icon(Icons.arrow_upward, color: Colors.red),
                            title: Text(pengeluaran.judul),
                            subtitle: Text(formatUang(pengeluaran.jumlahUang)),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _deletePengeluaran(
                                    pengeluaran.idPengeluaran!);
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePemasukan(int idPemasukan) async {
    await DBHelper.deletePemasukan(idPemasukan);
    _refreshList();
  }

// Fungsi untuk menghapus pengeluaran
  Future<void> _deletePengeluaran(int idPengeluaran) async {
    await DBHelper.deletePengeluaran(idPengeluaran);
    _refreshList();
  }

  void _navigateToTambahPemasukan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPemasukan(dompetId: widget.dompet.idDompet!),
      ),
    ).then((_) => _refreshList());
  }

  void _navigateToTambahPengeluaran(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPengeluaran(dompetId: widget.dompet.idDompet!),
      ),
    ).then((_) => _refreshList());
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(fontFamily: 'Lato')),
        content: Text(
            'Apakah Anda yakin ingin menghapus dompet "${widget.dompet.namaDompet}"?',
            style: TextStyle(fontFamily: 'Lato')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Lato')),
          ),
          ElevatedButton(
            onPressed: () async {
              await DBHelper.deleteDompet(widget.dompet.idDompet!);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white, fontFamily: 'Lato')),
          ),
        ],
      ),
    );
  }
}

class TambahPengeluaran extends StatelessWidget {
  final int dompetId;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  TambahPengeluaran({required this.dompetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengeluaran', style: TextStyle(fontFamily: 'Lato')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(
                labelText: 'Judul Pengeluaran',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahController,
              decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Validasi input
                if (_judulController.text.isEmpty ||
                    _jumlahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua kolom wajib diisi')),
                  );
                  return;
                }

                // Simpan pengeluaran ke database
                final pengeluaran = Pengeluaran(
                  idDompet: dompetId,
                  judul: _judulController.text,
                  kategori:
                      'Lainnya', // Tambahkan logika kategori jika diperlukan
                  tanggalDibuat: DateTime.now(),
                  jumlahUang: double.tryParse(_jumlahController.text) ?? 0.0,
                );
                await DBHelper.insertPengeluaran(pengeluaran.toMap());
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: Text('Simpan', style: TextStyle(fontFamily: 'Lato')),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahPemasukan extends StatelessWidget {
  final int dompetId;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  TambahPemasukan({required this.dompetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pemasukan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _jumlahController,
              decoration: InputDecoration(labelText: 'Jumlah Uang'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                final pemasukan = Pemasukan(
                  idDompet: dompetId,
                  judul: _judulController.text,
                  kategori: 'Lainnya',
                  tanggalDibuat: DateTime.now(),
                  jumlahUang: double.tryParse(_jumlahController.text) ?? 0.0,
                );
                await DBHelper.insertPemasukan(pemasukan.toMap());
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahDompet extends StatelessWidget {
  final Function refreshList;

  TambahDompet({required this.refreshList});

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _saldoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Tambah Dompet',
              style: TextStyle(fontFamily: 'Lato'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Dompet',
                labelStyle: TextStyle(
                  fontFamily: 'Lato',
                ),
              ),
              style: TextStyle(
                fontFamily: 'Lato',
              ),
            ),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Saldo Awal',
                labelStyle: TextStyle(
                  fontFamily: 'Lato',
                ),
              ),
              style: TextStyle(
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newDompet = Dompet(
                  namaDompet: _namaController.text,
                  jumlahUang: double.tryParse(_saldoController.text) ?? 0.0,
                );
                await DBHelper.insertDompet(newDompet);
                refreshList();
                Navigator.pop(context);
              },
              child: const Text(
                'Simpan',
                style: TextStyle(fontFamily: 'Lato'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
