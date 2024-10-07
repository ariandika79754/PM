import 'package:flutter/material.dart';

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasien;
  final Function(Map<String, dynamic>) onDelete; // Callback untuk hapus data

  DetailPasienScreen({required this.pasien, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pasien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama           : ${pasien['name']}'),
            SizedBox(height: 8),
            Text('Tanggal        : ${pasien['tanggal']}'),
            SizedBox(height: 8),
            Text('Umur           : ${pasien['umur']}'),
            SizedBox(height: 8),
            Text('Status         : ${pasien['status']}'),
            SizedBox(height: 8),
            Text('Diagnosa       : ${pasien['diagnosa']}'),
            SizedBox(height: 8),
            Text('Obat           : ${pasien['obat']}'),
            SizedBox(height: 8),
            Text('Jumlah Obat : ${pasien['jumlah_obat']}'),
            SizedBox(height: 8),
            Text('Dokter         : ${pasien['dokter']}'),
            SizedBox(height: 8),
            Text('Catatan        : ${pasien['catatan']}'),
            Spacer(), // Menambahkan spacer untuk mendorong tombol ke bawah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  onPressed: () {
                    // Logika untuk tombol edit (bisa diarahkan ke form edit jika diperlukan)
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  onPressed: () {
                    _showDeleteConfirmationDialog(
                        context); // Memunculkan dialog konfirmasi hapus
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Warna tombol delete
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.print),
                  label: Text('Print'),
                  onPressed: () {
                    _printData(); // Memanggil fungsi cetak data pasien
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mencetak data pasien
  void _printData() {
    print('Data Pasien:');
    print('Tanggal: ${pasien['tanggal']}');
    print('Nama: ${pasien['name']}');
    print('Umur: ${pasien['umur']}');
    print('Status: ${pasien['status']}');
    print('Diagnosa: ${pasien['diagnosa']}');
    print('Obat: ${pasien['obat']}');
    print('Jumlah Obat: ${pasien['jumlah_obat']}');
    print('Dokter: ${pasien['dokter']}');
    print('Catatan: ${pasien['catatan']}');
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data pasien ini?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Ketika OK ditekan, hapus pasien dan kembali ke halaman PasienScreen
                onDelete(pasien); // Menghapus pasien
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                Navigator.of(context)
                    .pop(true); // Kembali ke halaman sebelumnya (PasienScreen)
              },
            ),
          ],
        );
      },
    );
  }
}
