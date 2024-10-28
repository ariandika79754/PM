import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_alat_gula_darah_screen.dart';
import 'tambah_alat_gula_darah_screen.dart';

class AlatGulaDarahScreen extends StatefulWidget {
  @override
  _AlatGulaDarahScreenState createState() => _AlatGulaDarahScreenState();
}

class _AlatGulaDarahScreenState extends State<AlatGulaDarahScreen> {
  List<Map<String, dynamic>> alatList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAlatList();
  }

  Future<void> _loadAlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? alatString = prefs.getString('alatList');
    if (alatString != null) {
      setState(() {
        alatList = List<Map<String, dynamic>>.from(json.decode(alatString));
      });
    }
  }

  Future<void> _saveAlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String alatString = json.encode(alatList);
    await prefs.setString('alatList', alatString);
  }

  void _filterAlat(String query) {
    setState(() {
      alatList = query.isEmpty
          ? List.from(alatList)
          : alatList
              .where((alat) =>
                  alat['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Alat Gula Darah',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Times New Roman',
            color: Colors.green,
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
                      hintText: 'Cari Alat Gula Darah',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: _filterAlat,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alatList.length,
              itemBuilder: (context, index) {
                final alat = alatList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(alat['photo']),
                    radius: 30,
                  ),
                  title: Text('Nama Alat: ${alat['name']}'),
                  subtitle: Text('Stok: ${alat['stok']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAlatGulaDarahScreen(
                          alatGulaDarah: alat,
                          onDeleteAlatGulaDarah: (deletedAlat) {
                            setState(() {
                              alatList.remove(deletedAlat);
                              _saveAlatList();
                            });
                          },
                          onEditAlatGulaDarah: (editedAlat) {
                            setState(() {
                              alatList[index] = editedAlat;
                              _saveAlatList();
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
              builder: (context) => TambahAlatGulaDarahScreen(
                onAddAlat: (name, model, serialNumber, stok) {
                  setState(() {
                    final newAlat = {
                      "name": name,
                      "model": model,
                      "serialNumber": serialNumber,
                      "stok": stok,
                      "photo": 'assets/images/alat_gula_darah.jpg',
                    };

                    // Cek apakah alat sudah ada di daftar
                    if (!alatList.any((alat) => alat['name'] == name)) {
                      alatList.add(newAlat);
                      _saveAlatList();
                    } else {
                      // Tambahkan logika untuk memberikan umpan balik jika alat sudah ada
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Alat sudah ada!')),
                      );
                    }
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
