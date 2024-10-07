import 'package:flutter/material.dart';

class EditDokterScreen extends StatefulWidget {
  final Map<String, dynamic> dokter;

  EditDokterScreen({required this.dokter});

  @override
  _EditDokterScreenState createState() => _EditDokterScreenState();
}

class _EditDokterScreenState extends State<EditDokterScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Mengisi TextEditingController dengan data dokter yang sudah ada
    _nameController = TextEditingController(text: widget.dokter['name']);
  }

  @override
  void dispose() {
    _nameController.dispose(); // Bersihkan controller saat screen ditutup
    super.dispose();
  }

  void _saveChanges() {
    // Simpan perubahan yang dilakukan pada data dokter
    setState(() {
      widget.dokter['name'] = _nameController.text;
    });

    // Kembali ke halaman sebelumnya setelah menyimpan
    Navigator.pop(context, widget.dokter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dokter'),
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
            Container(
              padding: const EdgeInsets.all(8.0), // Padding untuk dalam box
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green, // Warna border hijau
                  width: 2.0, // Ketebalan border
                ),
                borderRadius:
                    BorderRadius.circular(8.0), // Border dengan radius
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Dokter',
                  border:
                      InputBorder.none, // Hilangkan border default TextField
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
