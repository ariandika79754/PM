import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
                    _generatePdf(context); // Memanggil fungsi cetak PDF
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mencetak data pasien ke PDF
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Membuat konten PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detail Pasien', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Nama: ${pasien['name']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Tanggal: ${pasien['tanggal']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Umur: ${pasien['umur']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Status: ${pasien['status']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Diagnosa: ${pasien['diagnosa']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Obat: ${pasien['obat']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Jumlah Obat: ${pasien['jumlah_obat']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Dokter: ${pasien['dokter']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Catatan: ${pasien['catatan']}', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    // Simpan file PDF ke direktori aplikasi
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/detail_pasien.pdf');

    await file.writeAsBytes(await pdf.save());

    // Menampilkan pesan bahwa file berhasil disimpan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF berhasil diunduh di ${file.path}')),
    );
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
