import 'package:flutter/material.dart';

class TambahDokterScreen extends StatelessWidget {
  final Function(String) onAddDokter;
  final String? initialDokter;

  TambahDokterScreen({required this.onAddDokter, this.initialDokter});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Jika initialDokter tidak null, set nilai TextField dengan initialDokter
    if (initialDokter != null) {
      _nameController.text = initialDokter!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Dokter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              onAddDokter(
                  _nameController.text); // Panggil fungsi untuk menambah dokter
              Navigator.pop(context); // Kembali setelah menyimpan
            },
            child: Text(
              'Simpan',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(Icons.person, 'Nama Dokter', _nameController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon), // Ikon di depan TextField
            labelText: label, // Label TextField
            border: InputBorder.none, // Menghilangkan border default
          ),
        ),
      ),
    );
  }
}
