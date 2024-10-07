import 'package:flutter/material.dart';
import 'tambah_dokter_screen.dart';

class DetailDokterScreen extends StatelessWidget {
  final Map<String, dynamic> dokter;
  final Function(Map<String, dynamic>) onDeleteDokter;
  final Function(Map<String, dynamic>) onEditDokter;

  DetailDokterScreen({
    required this.dokter,
    required this.onDeleteDokter,
    required this.onEditDokter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Dokter'),
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
            _buildDetailRow('Nama Dokter', dokter['name']),
            // Tambahkan detail lain jika ada
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Pindah ke layar TambahDokterScreen untuk edit
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahDokterScreen(
                        onAddDokter: (String name) {
                          dokter['name'] = name;
                          onEditDokter(dokter);
                        },
                        initialDokter: dokter['name'], // Isi awal untuk edit
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  size: 18,
                ),
                label: Text('Edit'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Hapus Dokter'),
                      content:
                          Text('Apakah Anda yakin ingin menghapus dokter ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDeleteDokter(dokter);
                            Navigator.pop(context);
                            Navigator.pop(context, dokter); // Hapus dokter
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 18,
                ),
                label: Text('Hapus'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Ubah ke start
        children: [
          Text(
            '$label',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5), // Jarak kecil antara label dan titik dua
          Text(': $value'), // Titik dua dan nilai
        ],
      ),
    );
  }
}
