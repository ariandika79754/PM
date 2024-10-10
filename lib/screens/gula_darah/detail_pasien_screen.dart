import 'package:flutter/material.dart';

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
        title: Text('Detail Cek Laborat'),
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
                    print('Print pressed'); // Placeholder untuk tombol print
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0), // Kurangi padding untuk mengecilkan header
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0), // Kurangi padding untuk mengecilkan sel
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
