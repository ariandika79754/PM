import 'package:flutter/material.dart';

class TambahAlatGulaDarahScreen extends StatefulWidget {
  final Function(String, String, String, int) onAddAlat;
  final Map<String, dynamic>? initialAlat;

  TambahAlatGulaDarahScreen({required this.onAddAlat, this.initialAlat});

  @override
  _TambahAlatGulaDarahScreenState createState() =>
      _TambahAlatGulaDarahScreenState();
}

class _TambahAlatGulaDarahScreenState extends State<TambahAlatGulaDarahScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialAlat != null) {
      _nameController.text = widget.initialAlat!['name'] ?? '';
      _modelController.text = widget.initialAlat!['model'] ?? '';
      _serialNumberController.text = widget.initialAlat!['serialNumber'] ?? '';
      _stockController.text =
          widget.initialAlat!['stock']?.toString() ?? ''; // Initialize stock
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Alat Gula Darah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
                Icons.medical_services, 'Nama Alat', _nameController),
            _buildInputField(Icons.model_training, 'Model', _modelController),
            _buildInputField(
                Icons.vpn_key, 'Nomor Seri', _serialNumberController),
            _buildInputField(Icons.inventory, 'Stok', _stockController,
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String name = _nameController.text;
                final String model = _modelController.text;
                final String serialNumber = _serialNumberController.text;
                final int stock = int.tryParse(_stockController.text) ?? 0;

                widget.onAddAlat(name, model, serialNumber, stock);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
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
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
