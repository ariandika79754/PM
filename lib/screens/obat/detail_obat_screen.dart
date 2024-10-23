import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'tambah_obat_screen.dart';

class DetailObatScreen extends StatelessWidget {
  final Map<String, dynamic> obat;
  final Function(Map<String, dynamic>) onEdit;
  final Function() onDelete;

  DetailObatScreen({
    required this.obat,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nama Obat', obat['name']),
            SizedBox(height: 10),
            _buildInfoRow('Stok', obat['stok'].toString()),
            SizedBox(height: 10),
            _buildInfoRow('Keterangan', obat['keterangan']),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: () async {
                final updatedObat = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahObatScreen(obat: obat),
                  ),
                );
                if (updatedObat != null) {
                  onEdit(updatedObat);
                  Navigator.pop(context);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              onPressed: () {
                generatePdf(context); // Mengirimkan context
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5),
        Text(': $value'),
      ],
    );
  }

  Future<void> generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Membuat konten PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detail Obat', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Nama Obat: ${obat['name']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Stok: ${obat['stok']}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 5),
            pw.Text('Keterangan: ${obat['keterangan']}', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    // Simpan file PDF ke direktori aplikasi
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/detail_obat.pdf');

    await file.writeAsBytes(await pdf.save());

    // Buka file PDF yang sudah disimpan
    await OpenFile.open(file.path);

    // Menampilkan pesan bahwa file berhasil disimpan dan dibuka
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF berhasil dibuat dan dibuka di ${file.path}')),
    );
  }
}
