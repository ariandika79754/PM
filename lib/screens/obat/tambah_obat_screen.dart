import 'package:flutter/material.dart';

class TambahObatScreen extends StatefulWidget {
  final Map<String, dynamic>? obat;

  TambahObatScreen({this.obat});

  @override
  _TambahObatScreenState createState() => _TambahObatScreenState();
}

class _TambahObatScreenState extends State<TambahObatScreen> {
  final _nameController = TextEditingController();
  final _stokController = TextEditingController();
  final _keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.obat != null) {
      _nameController.text = widget.obat!['name'];
      _stokController.text = widget.obat!['stok'].toString();
      _keteranganController.text = widget.obat!['keterangan'];
    }
  }

  void _saveObat() {
    final newObat = {
      "name": _nameController.text,
      "stok": int.parse(_stokController.text),
      "keterangan": _keteranganController.text,
      "image":
          "assets/images/obat1.png", // Gambar default atau tambahkan logika pemilih gambar
    };
    Navigator.pop(context, newObat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.obat == null ? 'Tambah Obat' : 'Edit Obat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveObat,
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
            _buildInputField(
                Icons.medical_services, 'Nama Obat', _nameController),
            _buildInputField(Icons.bookmark, 'Stok', _stokController),
            _buildInputField(
                Icons.description, 'Keterangan', _keteranganController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
