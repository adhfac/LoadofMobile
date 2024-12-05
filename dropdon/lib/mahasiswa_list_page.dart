import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';  // Import fl_chart
import 'mahasiswa.dart';

class MahasiswaListPage extends StatefulWidget {
  @override
  _MahasiswaListPageState createState() => _MahasiswaListPageState();
}

class _MahasiswaListPageState extends State<MahasiswaListPage> {
  List<Mahasiswa> mahasiswaList = [];
  String? selectedJenisKelaminFilter;

  @override
  void initState() {
    super.initState();
    _loadMahasiswa();
  }

  void _loadMahasiswa() {
    var box = Hive.box('mahasiswaBox');
    setState(() {
      mahasiswaList = box.values.map((data) {
        var map = Map<String, dynamic>.from(data);
        return Mahasiswa.fromMap(map);
      }).toList();

      // Filter based on gender if selected
      if (selectedJenisKelaminFilter != null) {
        mahasiswaList = mahasiswaList.where((mahasiswa) {
          return mahasiswa.jenisKelamin == selectedJenisKelaminFilter;
        }).toList();
      }
    });
  }

  void _showAddMahasiswaDialog() {
    TextEditingController nimController = TextEditingController();
    TextEditingController namaController = TextEditingController();
    String? jenisKelamin;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Mahasiswa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM'),
              ),
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (value) {
                  jenisKelamin = value;
                },
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
            ElevatedButton(
              onPressed: () {
                if (nimController.text.isNotEmpty &&
                    namaController.text.isNotEmpty &&
                    jenisKelamin != null) {
                  _addMahasiswa(Mahasiswa(
                    nim: nimController.text,
                    nama: namaController.text,
                    jenisKelamin: jenisKelamin!,
                  ));
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

  void _addMahasiswa(Mahasiswa mahasiswa) {
    var box = Hive.box('mahasiswaBox');
    box.add(mahasiswa.toMap());
    _loadMahasiswa(); // Reload data after adding
  }

  void _deleteMahasiswa(int index) {
    var box = Hive.box('mahasiswaBox');
    box.deleteAt(index);  // Delete data by index
    _loadMahasiswa(); // Reload data after deleting
  }

  List<PieChartSectionData> _generatePieChartSections() {
    int maleCount = mahasiswaList.where((m) => m.jenisKelamin == 'Laki-laki').length;
    int femaleCount = mahasiswaList.where((m) => m.jenisKelamin == 'Perempuan').length;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: maleCount.toDouble(),
        title: 'Laki-laki: $maleCount',
        radius: 40,
      ),
      PieChartSectionData(
        color: Colors.pink,
        value: femaleCount.toDouble(),
        title: 'Perempuan: $femaleCount',
        radius: 40,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Mahasiswa'),
      ),
      body: Column(
        children: [
          // Dropdown for filtering by gender
          DropdownButton<String>(
            value: selectedJenisKelaminFilter,
            hint: Text('Filter Jenis Kelamin'),
            items: [
              DropdownMenuItem(value: null, child: Text('Semua')),
              DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
              DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
            ],
            onChanged: (value) {
              setState(() {
                selectedJenisKelaminFilter = value;
              });
              _loadMahasiswa(); // Reload data after filter
            },
          ),
          
          // Pie chart to show the number of male and female students
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _generatePieChartSections(),
                centerSpaceRadius: 30,
              ),
            ),
          ),
          
          // Table of students
          Expanded(
            child: ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final mahasiswa = mahasiswaList[index];
                return ListTile(
                  title: Text(mahasiswa.nama),
                  subtitle: Text('${mahasiswa.nim} - ${mahasiswa.jenisKelamin}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteMahasiswa(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMahasiswaDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
