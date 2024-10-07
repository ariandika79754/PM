import 'package:flutter/material.dart';
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
                // Aksi print
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Ubah ke start
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5), // Jarak kecil antara label dan titik dua
        Text(': $value'), // Titik dua dan nilai
      ],
    );
  }
}
