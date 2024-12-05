class Mahasiswa {
  final String nim;
  final String nama;
  final String jenisKelamin;

  Mahasiswa({required this.nim, required this.nama, required this.jenisKelamin});

  // Fungsi untuk mengubah objek Mahasiswa menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'nim': nim,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
    };
  }

  // Fungsi untuk membuat objek Mahasiswa dari Map
  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      nim: map['nim'],
      nama: map['nama'],
      jenisKelamin: map['jenisKelamin'],
    );
  }
}
