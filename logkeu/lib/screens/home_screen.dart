import 'package:flutter/material.dart';
import 'package:logkeu/db_helper.dart';
import 'package:logkeu/models/dompet.dart';
import 'package:logkeu/screens/detail_dompet.dart';

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
          'No More Broke Boi',
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
