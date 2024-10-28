import 'package:flutter/material.dart';
import 'tambah_alat_gula_darah_screen.dart';

class DetailAlatGulaDarahScreen extends StatelessWidget {
  final Map<String, dynamic> alatGulaDarah;
  final Function(Map<String, dynamic>) onDeleteAlatGulaDarah;
  final Function(Map<String, dynamic>) onEditAlatGulaDarah;

  DetailAlatGulaDarahScreen({
    required this.alatGulaDarah,
    required this.onDeleteAlatGulaDarah,
    required this.onEditAlatGulaDarah,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Alat Gula Darah'),
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
            _buildDetailRow('Nama Alat', alatGulaDarah['name']),
            _buildDetailRow('Model', alatGulaDarah['model']),
            _buildDetailRow('Nomor Seri', alatGulaDarah['serialNumber']),
            _buildDetailRow('Stok', alatGulaDarah['stok'].toString()),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahAlatGulaDarahScreen(
                        onAddAlat: (String name, String model, String serialNumber, int stok) {
                          alatGulaDarah['name'] = name;
                          alatGulaDarah['model'] = model;
                          alatGulaDarah['serialNumber'] = serialNumber;
                          alatGulaDarah['stok'] = stok;
                          onEditAlatGulaDarah(alatGulaDarah);
                        },
                        initialAlat: {
                          'name': alatGulaDarah['name'],
                          'model': alatGulaDarah['model'],
                          'serialNumber': alatGulaDarah['serialNumber'],
                          'stok': alatGulaDarah['stok']
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, size: 18),
                label: Text('Edit'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Hapus Alat'),
                      content: Text('Apakah Anda yakin ingin menghapus alat ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDeleteAlatGulaDarah(alatGulaDarah);
                            Navigator.pop(context);
                            Navigator.pop(context, alatGulaDarah);
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete, size: 18),
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
        children: [
          Text('$label', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Text(': $value'),
        ],
      ),
    );
  }
}
