import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'tambah_pasien_screen.dart';

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasien;
  final Function(Map<String, dynamic>) onDelete; // Callback untuk hapus data
  final Function(Map<String, dynamic>) onUpdate; // Callback untuk update data

  DetailPasienScreen({required this.pasien, required this.onDelete, required this.onUpdate});

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
            Text('Prodi         : ${pasien['prodi']}'),
            SizedBox(height: 8),
            Text('Jurusan       : ${pasien['jurusan']}'),
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahPasienScreen(
                          onAddPasien: (updatedPasien) {
                            onUpdate(updatedPasien); // Panggil onUpdate dengan pasien baru
                            Navigator.of(context).pop(); // Kembali
                          },
                          pasien: pasien, // Kirim data pasien untuk diedit
                          obatList: [], // Isi dengan daftar obat yang tersedia
                          dokterList: [], // Isi dengan daftar dokter yang tersedia
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.print),
                  label: Text('Print'),
                  onPressed: () {
                    _generatePdf(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detail Pasien', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Nama           : ${pasien['name']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Tanggal        : ${pasien['tanggal']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Umur           : ${pasien['umur']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Status         : ${pasien['status']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Diagnosa       : ${pasien['diagnosa']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Obat           : ${pasien['obat']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Jumlah Obat    : ${pasien['jumlah_obat']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Dokter         : ${pasien['dokter']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Catatan        : ${pasien['catatan']}', style: pw.TextStyle(fontSize: 18)),
          ],
        ); 
      },
    ),
  );

  // Simpan PDF
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/detail_pasien_${pasien['name']}.pdf");
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(file.path); // Buka PDF setelah disimpan
}


  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus pasien ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onDelete(pasien); // Panggil fungsi hapus
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(true); // Kembali ke PasienScreen
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
