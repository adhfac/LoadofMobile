import 'package:flutter/material.dart';
import 'package:logkeu/db_helper.dart';
import 'package:logkeu/models/dompet.dart';
import 'package:logkeu/models/pemasukan.dart';
import 'package:logkeu/models/pengeluaran.dart';

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

  String _formatDate(DateTime date) {
    const List<String> bulan = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return "${date.day} ${bulan[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dompet.namaDompet,
            style: TextStyle(fontFamily: 'Lato')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color.fromARGB(255, 255, 20, 3)),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Dompet: ${widget.dompet.namaDompet}',
                        style:
                            const TextStyle(fontFamily: 'Lato', fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Saldo: ${formatUang(widget.dompet.jumlahUang)}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _navigateToTambahPemasukan(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 91, 147, 0),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Pemasukan',
                        style:
                            TextStyle(fontFamily: 'Lato', color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToTambahPengeluaran(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 0, 0),
                    ),
                    icon: const Icon(Icons.remove, color: Colors.white),
                    label: const Text('Pengeluaran',
                        style:
                            TextStyle(fontFamily: 'Lato', color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: Future.wait([_pemasukanList, _pengeluaranList]),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontFamily: 'Lato'),
                      ),
                    );
                  } else {
                    final pemasukanList =
                        snapshot.data[0] as List<Map<String, dynamic>>;
                    final pengeluaranList =
                        snapshot.data[1] as List<Map<String, dynamic>>;

                    return Column(
                      children: [
                        _buildSectionHeader(
                            'Pemasukan', Icons.arrow_downward, Colors.green),
                        ...pemasukanList.map((data) => _buildListItem(
                              data: Pemasukan.fromMap(data),
                              icon: Icons.arrow_downward,
                              iconColor: Colors.green,
                              onDelete: () async =>
                                  await _deletePemasukan(data['idPemasukan']),
                            )),
                        const Divider(),
                        _buildSectionHeader(
                            'Pengeluaran', Icons.arrow_upward, Colors.red),
                        ...pengeluaranList.map((data) => _buildListItem(
                              data: Pengeluaran.fromMap(data),
                              icon: Icons.arrow_upward,
                              iconColor: Colors.red,
                              onDelete: () async => await _deletePengeluaran(
                                  data['idPengeluaran']),
                            )),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required dynamic data,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onDelete,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(data.judul, style: const TextStyle(fontFamily: 'Lato')),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatUang(data.jumlahUang),
                style: const TextStyle(fontFamily: 'Lato')),
            Text(_formatDate(data.tanggalDibuat),  style: const TextStyle(fontFamily: 'Lato'))
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Future<void> _deletePengeluaran(int idPengeluaran) async {
    await DBHelper.deletePengeluaran(idPengeluaran);
    _refreshList();
  }

  Future<void> _deletePemasukan(int idPemasukan) async {
    await DBHelper.deletePemasukan(idPemasukan);
    _refreshList();
  }

  void _navigateToTambahPemasukan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPemasukan(dompetId: widget.dompet.idDompet!),
      ),
    ).then((result) {
      if (result == true) _refreshList();
    });
  }

  void _navigateToTambahPengeluaran(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahPengeluaran(dompetId: widget.dompet.idDompet!),
      ),
    ).then((result) {
      if (result == true) _refreshList();
    });
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

class TambahPengeluaran extends StatefulWidget {
  final int dompetId;

  TambahPengeluaran({required this.dompetId});

  @override
  _TambahPengeluaranState createState() => _TambahPengeluaranState();
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String _selectedKategori = 'Makanan';
  DateTime _selectedDate = DateTime.now();

  final List<String> _kategoriList = [
    'Makanan',
    'Berbelanja',
    'Hiburan',
    'Rumah tangga',
    'Keluarga',
    'Kesehatan',
    'Liburan',
    'Tagihan',
    'Lain'
  ];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Tambah Pengeluaran',
        style: TextStyle(fontFamily: 'Lato'),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              style: TextStyle(fontFamily: 'Lato'),
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
            ),
            TextField(
              controller: _jumlahController,
              style: TextStyle(fontFamily: 'Lato'),
              decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedKategori,
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(
                    kategori,
                    style: TextStyle(fontFamily: 'Lato'),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKategori = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tanggal: ${_formatDate(_selectedDate)}',
                    style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontFamily: 'Lato'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_judulController.text.isEmpty ||
                    _jumlahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      'Semua kolom wajib diisi',
                      style: TextStyle(fontFamily: 'Lato'),
                    )),
                  );
                  return;
                }

                final pengeluaran = Pengeluaran(
                  idDompet: widget.dompetId,
                  judul: _judulController.text,
                  kategori: _selectedKategori,
                  tanggalDibuat: _selectedDate,
                  jumlahUang: double.tryParse(_jumlahController.text) ?? 0.0,
                );
                await DBHelper.insertPengeluaran(pengeluaran.toMap());

                Navigator.pop(context, true);
              },
              child: Text(
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

class TambahPemasukan extends StatefulWidget {
  final int dompetId;

  TambahPemasukan({required this.dompetId});

  @override
  _TambahPemasukanState createState() => _TambahPemasukanState();
}

class _TambahPemasukanState extends State<TambahPemasukan> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String _selectedKategori = 'Pendapatan';
  DateTime _selectedDate = DateTime.now();

  final List<String> _kategoriList = ['Pendapatan', 'Beasiswa', 'Lain'];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Tambah Pemasukan',
        style: TextStyle(fontFamily: 'Lato'),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              style: TextStyle(fontFamily: 'Lato'),
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
            ),
            TextField(
              controller: _jumlahController,
              style: TextStyle(fontFamily: 'Lato'),
              decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedKategori,
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(
                    kategori,
                    style: TextStyle(fontFamily: 'Lato'),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKategori = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: TextStyle(fontFamily: 'Lato'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tanggal: ${_formatDate(_selectedDate)}',
                    style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontFamily: 'Lato'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_judulController.text.isEmpty ||
                    _jumlahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      'Semua kolom wajib diisi',
                      style: TextStyle(fontFamily: 'Lato'),
                    )),
                  );
                  return;
                }
                final pemasukan = Pemasukan(
                  idDompet: widget.dompetId,
                  judul: _judulController.text,
                  kategori: _selectedKategori,
                  tanggalDibuat: _selectedDate,
                  jumlahUang: double.tryParse(_jumlahController.text) ?? 0.0,
                );
                await DBHelper.insertPemasukan(pemasukan.toMap());
                Navigator.pop(context, true);
              },
              child: Text(
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
