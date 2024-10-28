import 'package:flutter/material.dart';

class DetailAlatGulaDarahScreen extends StatelessWidget {
  final Map<String, dynamic> alatGulaDarah;

  DetailAlatGulaDarahScreen({
    required this.alatGulaDarah,
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
