import 'package:flutter/material.dart';

class ObatScreen extends StatefulWidget {
  @override
  _ObatScreenState createState() => _ObatScreenState();
}

class _ObatScreenState extends State<ObatScreen> {
 List<Map<String, dynamic>> obatList = []; 

  void _addObat(Map<String, dynamic> newObat) {
    setState(() {
      obatList.add(newObat);
    });
  }

  void _editObat(int index, Map<String, dynamic> updatedObat) {
    setState(() {
      obatList[index] = updatedObat;
    });
  }

  void _deleteObat(int index) {
    setState(() {
      obatList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Obat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Obat',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: obatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(obatList[index]['image']),
                    radius: 30,
                  ),
                  title: Text('Nama Obat: ${obatList[index]['name']}'),
                  subtitle: Text('Stok: ${obatList[index]['stok']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailObatScreen(
                          obat: obatList[index],
                          onEdit: (updatedObat) =>
                              _editObat(index, updatedObat),
                          onDelete: () => _deleteObat(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newObat = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahObatScreen()),
          );
          if (newObat != null) {
            _addObat(newObat);
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nama Obat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(': ${obat['name']}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stok',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(': ${obat['stok']}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keterangan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(': ${obat['keterangan']}'),
              ],
            ),
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
              iconSize: 20,
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
              iconSize: 20,
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              iconSize: 20,
              onPressed: () {
                // Aksi print
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
          "assets/images/obat1.png", // Default image or implement image picker
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
