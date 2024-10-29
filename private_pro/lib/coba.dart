void main() {
  Mahasiswa mhs = new Mahasiswa('John', 25);
  mhs.cetakData();
}

class Mahasiswa {
  String nama;
  int umur;

  Mahasiswa(this.nama, this.umur);

  void cetakData() {
    print('Halo nama saya $nama, saya berumur $umur tahun');
  }
}