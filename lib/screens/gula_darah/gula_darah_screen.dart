import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Untuk mengonversi data pasien ke format JSON
import 'add_pasien_screen.dart';
import 'detail_pasien_screen.dart';

class GulaDarahScreen extends StatefulWidget {
  @override
  _GulaDarahScreenState createState() => _GulaDarahScreenState();
}

class _GulaDarahScreenState extends State<GulaDarahScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> pasienGulaDarahList =
      []; // List untuk menyimpan data pasien
  List<Map<String, dynamic>> filteredPasienGulaDarahList =
      []; // List untuk menyimpan hasil filter
  List<Map<String, dynamic>> alatList = [];
  @override
  void initState() {
    super.initState();
    _loadPasienList(); // Memuat data pasien dari shared preferences
    _searchController.addListener(
        _filterPasienList); // Menambahkan listener pada search input
  }

  // Fungsi untuk memuat data pasien dari shared preferences
  Future<void> _loadPasienList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pasienData = prefs.getString('pasienGulaDarahList');
    if (pasienData != null) {
      setState(() {
        pasienGulaDarahList =
            List<Map<String, dynamic>>.from(json.decode(pasienData));
        filteredPasienGulaDarahList = pasienGulaDarahList; // Set daftar filter
      });
    }
  }

  // Fungsi untuk menyimpan data pasien ke shared preferences
  Future<void> _savePasienList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pasienData = json.encode(pasienGulaDarahList);
    await prefs.setString('pasienGulaDarahList', pasienData);
  }

  // Fungsi untuk memfilter daftar pasien berdasarkan nama
  void _filterPasienList() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredPasienGulaDarahList =
            pasienGulaDarahList; // Jika tidak ada pencarian, tampilkan semua data
      } else {
        filteredPasienGulaDarahList = pasienGulaDarahList
            .where((pasien) => pasien['nama'].toLowerCase().contains(query))
            .toList(); // Filter pasien berdasarkan nama
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Cek Laboratorium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextField(
                      controller:
                          _searchController, // Menghubungkan controller pencarian
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search Pasien',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredPasienGulaDarahList.isEmpty
                  ? Center(child: Text("Belum Ada Data Pasien"))
                  : ListView.builder(
                      itemCount: filteredPasienGulaDarahList.length,
                      itemBuilder: (context, index) {
                        var pasien = filteredPasienGulaDarahList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/gula_darah.png'),
                          ),
                          title: Text(pasien['nama']),
                          subtitle: Text(pasien['tanggal']),
                          onTap: () {
                            // Navigasi ke DetailPasienScreen dengan callback edit dan delete
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPasienScreen(
                                  pasienData: pasien,
                                  onDelete: () {
                                    setState(() {
                                      pasienGulaDarahList
                                          .removeAt(index); // Hapus data
                                    });
                                    _savePasienList(); // Simpan perubahan
                                  },
                                  onEdit: (editedData) async {
                                    // Navigasi ke halaman AddPasienScreen dengan data yang ingin diedit
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPasienScreen(
                                            pasienData: pasien,
                                            alatList: alatList),
                                      ),
                                    );

                                    if (result != null &&
                                        result is Map<String, dynamic>) {
                                      setState(() {
                                        pasienGulaDarahList[index] =
                                            result; // Update data
                                      });
                                      _savePasienList(); // Simpan perubahan
                                    }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPasienScreen(alatList: alatList),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              pasienGulaDarahList
                  .add(result); // Tambahkan pasien baru ke daftar
            });
            _savePasienList(); // Simpan data ke shared preferences
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
