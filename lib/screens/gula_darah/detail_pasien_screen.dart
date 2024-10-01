import 'package:flutter/material.dart';

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasienData;

  DetailPasienScreen({required this.pasienData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cek Laborat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem("Nama Pasien :", pasienData['nama']),
            _buildDetailItem("Status      :", pasienData['status']),
            _buildDetailItem("Prodi       :", pasienData['prodi']),
            _buildDetailItem("Jurusan     :", pasienData['jurusan']),
            _buildDetailItem("Tanggal     :", pasienData['tanggal']),
            _buildDetailItem("Hasil       :", pasienData['keterangan']),
            SizedBox(height: 20),
            Text(
              "Pemeriksaan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Tabel pemeriksaan
            Table(
              border: TableBorder.all(), // Border untuk tabel
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
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
                _buildTableRow(
                    'Cek Gula Darah', pasienData['gula_darah'], '<100 mg/dL'),
                _buildTableRow('Tensi', pasienData['tensi'], '120/70 mmHg'),
                _buildTableRow(
                    'Kolestrol', pasienData['kolestrol'], '<200 mg/dL'),
                _buildTableRow(
                    'Asam Urat', pasienData['asam_urat'], '<6 mg/dL'),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat header tabel
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
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

  // Fungsi untuk membuat sel dalam tabel
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  // Fungsi untuk membuat item detail di atas tabel
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
}
