import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasienData;
  final Function onDelete; // Callback untuk menghapus pasien
  final Function onEdit; // Callback untuk mengedit pasien

  DetailPasienScreen({
    required this.pasienData,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cek Laboratorium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian detail pasien
            _buildDetailItem("Nama Pasien", pasienData['nama']),
            _buildDetailItem("Status", pasienData['status']),
            _buildDetailItem("Prodi", pasienData['prodi']),
            _buildDetailItem("Jurusan", pasienData['jurusan']),
            _buildDetailItem("Tanggal", pasienData['tanggal']),
            _buildDetailItem("Hasil", pasienData['keterangan']),
            SizedBox(height: 20),
            // Bagian tabel pemeriksaan
            Text(
              "Pemeriksaan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.black, width: 1), // Garis dalam
                outside: BorderSide(color: Colors.black, width: 1), // Garis luar, termasuk tepi kanan
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _buildTableHeader('Pemeriksaan'),
                    _buildTableHeader('Hasil'),
                    _buildTableHeader('Normal'),
                  ],
                ),
                _buildTableRow('Cek Gula Darah', pasienData['gula_darah'], '<100 mg/dL'),
                _buildTableRow('Tensi', pasienData['tensi'], '120/70 mmHg'),
                _buildTableRow('Kolestrol', pasienData['kolestrol'], '<200 mg/dL'),
                _buildTableRow('Asam Urat', pasienData['asam_urat'], '<6 mg/dL'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    onEdit(pasienData); // Panggil fungsi edit
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(context); // Konfirmasi hapus
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Warna tombol delete
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _generateAndOpenPdf(context); // Panggil fungsi generate dan buka PDF
                  },
                  icon: Icon(Icons.print),
                  label: Text('Print'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mencetak data pasien ke PDF dan langsung membukanya
  Future<void> _generateAndOpenPdf(BuildContext context) async {
    final pdf = pw.Document();

    // Membuat konten PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Detail Cek Laboratorium', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            _buildPdfDetailItem('Nama Pasien', pasienData['nama']),
            _buildPdfDetailItem('Status', pasienData['status']),
            _buildPdfDetailItem('Prodi', pasienData['prodi']),
            _buildPdfDetailItem('Jurusan', pasienData['jurusan']),
            _buildPdfDetailItem('Tanggal', pasienData['tanggal']),
            _buildPdfDetailItem('Hasil', pasienData['keterangan']),
            pw.SizedBox(height: 20),
            pw.Text('Pemeriksaan', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: ['Pemeriksaan', 'Hasil', 'Normal'],
              data: [
                ['Cek Gula Darah', pasienData['gula_darah'], '<100 mg/dL'],
                ['Tensi', pasienData['tensi'], '120/70 mmHg'],
                ['Kolestrol', pasienData['kolestrol'], '<200 mg/dL'],
                ['Asam Urat', pasienData['asam_urat'], '<6 mg/dL'],
              ],
            ),
          ],
        ),
      ),
    );

    // Simpan PDF ke direktori aplikasi
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/detail_laborat.pdf');
    await file.writeAsBytes(await pdf.save());

    // Buka file PDF yang sudah disimpan
    await OpenFile.open(file.path);

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF berhasil dibuat dan dibuka di ${file.path}')),
    );
  }

  // Fungsi untuk menampilkan item detail di PDF
  pw.Widget _buildPdfDetailItem(String label, String? value) {
    return pw.Row(
      children: [
        pw.Expanded(flex: 2, child: pw.Text("$label:")),
        pw.Expanded(flex: 3, child: pw.Text(value ?? 'N/A')),
      ],
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                onDelete(); // Panggil fungsi untuk menghapus data
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk membuat item detail
  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("$label:")),
          Expanded(flex: 3, child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  // Fungsi untuk membuat baris tabel
  TableRow _buildTableRow(String pemeriksaan, String? hasil, String normal) {
    return TableRow(
      children: [
        _buildTableCell(pemeriksaan),
        _buildTableCell(hasil ?? 'N/A'),
        _buildTableCell(normal),
      ],
    );
  }

  // Fungsi untuk membuat header tabel
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Fungsi untuk membuat sel tabel
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
