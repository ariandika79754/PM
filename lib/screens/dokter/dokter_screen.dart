import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:convert'; // Untuk encode/decode JSON
import 'detail_dokter_screen.dart'; // Import the detail screen
import 'tambah_dokter_screen.dart'; // Import the add screen

class DokterScreen extends StatefulWidget {
  @override
  _DokterScreenState createState() => _DokterScreenState();
}

class _DokterScreenState extends State<DokterScreen> {
  List<Map<String, dynamic>> dokterList = [];
  List<Map<String, dynamic>> filteredDokterList =
      []; // Daftar untuk menampung hasil filter
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDokterList(); // Load data dokter saat inisialisasi
  }

  // Fungsi untuk mengambil data dokter dari SharedPreferences
  Future<void> _loadDokterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dokterString = prefs.getString('dokterList');
    if (dokterString != null) {
      setState(() {
        dokterList = List<Map<String, dynamic>>.from(json.decode(dokterString));
        filteredDokterList =
            dokterList; // Inisialisasi daftar filter dengan daftar dokter
      });
    }
  }

  // Fungsi untuk menyimpan data dokter ke SharedPreferences
  Future<void> _saveDokterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dokterString = json.encode(dokterList);
    prefs.setString('dokterList', dokterString);
  }

  // Fungsi untuk memfilter daftar dokter berdasarkan pencarian
  void _filterDokter(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDokterList =
            dokterList; // Tampilkan semua dokter jika query kosong
      });
    } else {
      setState(() {
        filteredDokterList = dokterList.where((dokter) {
          return dokter['name']
              .toLowerCase()
              .contains(query.toLowerCase()); // Filter berdasarkan nama
        }).toList();
      });
    }
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
          'Dokter',
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Dokter',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      _filterDokter(
                          value); // Panggil fungsi filter saat input berubah
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  filteredDokterList.length, // Gunakan daftar hasil filter
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage(filteredDokterList[index]['photo']),
                    radius: 30,
                  ),
                  title:
                      Text('Nama Dokter: ${filteredDokterList[index]['name']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDokterScreen(
                          dokter: filteredDokterList[index],
                          onDeleteDokter: (deletedDokter) {
                            setState(() {
                              dokterList.remove(
                                  deletedDokter); // Hapus dokter dari daftar
                              filteredDokterList.remove(
                                  deletedDokter); // Hapus dari daftar filter
                              _saveDokterList(); // Simpan setelah dihapus
                            });
                          },
                          onEditDokter: (editedDokter) {
                            setState(() {
                              dokterList[index] =
                                  editedDokter; // Perbarui dokter yang diedit
                              filteredDokterList[index] =
                                  editedDokter; // Perbarui daftar filter
                              _saveDokterList(); // Simpan perubahan
                            });
                          },
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahDokterScreen(
                onAddDokter: (String name) {
                  setState(() {
                    dokterList.add({
                      "name": name,
                      "photo": 'assets/images/doctor1.png',
                    });
                    filteredDokterList.add({
                      "name": name,
                      "photo": 'assets/images/doctor1.png',
                    }); // Tambahkan dokter ke daftar filter
                    _saveDokterList(); // Simpan daftar dokter setelah penambahan
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
