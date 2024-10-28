import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:convert'; // Untuk encode/decode JSON
import 'detail_obat_screen.dart';
import 'tambah_obat_screen.dart';

class ObatScreen extends StatefulWidget {
  @override
  _ObatScreenState createState() => _ObatScreenState();
}

class _ObatScreenState extends State<ObatScreen> {
  List<Map<String, dynamic>> obatList = [];
  List<Map<String, dynamic>> filteredObatList =
      []; // List yang akan menampilkan hasil pencarian
  TextEditingController searchController =
      TextEditingController(); // Controller untuk input pencarian

  @override
  void initState() {
    super.initState();
    _loadObatList(); // Memuat data obat dari SharedPreferences saat inisialisasi
  }

  // Fungsi untuk memuat data obat dari SharedPreferences
  Future<void> _loadObatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? obatString = prefs.getString('obatList');
    if (obatString != null) {
      setState(() {
        obatList = List<Map<String, dynamic>>.from(json.decode(obatString));
        filteredObatList = obatList; // Awalnya tampilkan semua obat
      });
    }
  }

  // Fungsi untuk menyimpan data obat ke SharedPreferences
  Future<void> _saveObatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String obatString = json.encode(obatList);
    prefs.setString('obatList', obatString);
  }

  // Menambahkan obat baru
  void _addObat(Map<String, dynamic> newObat) {
    setState(() {
      obatList.add(newObat);
      _saveObatList(); // Simpan data obat setelah penambahan
      _filterObatList(searchController.text); // Filter ulang setelah penambahan
    });
  }

  // Mengedit obat yang ada
  void _editObat(int index, Map<String, dynamic> updatedObat) {
    setState(() {
      obatList[index] = updatedObat;
      _saveObatList(); // Simpan data obat setelah pengeditan
      _filterObatList(searchController.text); // Filter ulang setelah pengeditan
    });
  }

  // Menghapus obat
  void _deleteObat(int index) {
    setState(() {
      obatList.removeAt(index);
      _saveObatList(); // Simpan data obat setelah penghapusan
      _filterObatList(
          searchController.text); // Filter ulang setelah penghapusan
    });
  }

  // Fungsi untuk memfilter daftar obat berdasarkan query pencarian
  void _filterObatList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredObatList = obatList; // Tampilkan semua obat jika query kosong
      } else {
        filteredObatList = obatList
            .where((obat) =>
                obat['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
        title: Text(
          'Obat',
          style: TextStyle(
            fontSize: 28, // Ukuran font
            fontFamily: 'Times New Roman', // Font Latin
            color: Colors.green, // Warna hijau
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Obat',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (query) {
                      _filterObatList(
                          query); // Panggil fungsi filter saat query berubah
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  filteredObatList.length, // Tampilkan obat yang sudah difilter
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage(filteredObatList[index]['image']),
                    radius: 30,
                  ),
                  title: Text('Nama Obat: ${filteredObatList[index]['name']}'),
                  subtitle: Text('Stok: ${filteredObatList[index]['stok']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailObatScreen(
                          obat: filteredObatList[index],
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
