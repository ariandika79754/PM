import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_dokter_screen.dart';
import 'tambah_dokter_screen.dart';

class DokterScreen extends StatefulWidget {
  @override
  _DokterScreenState createState() => _DokterScreenState();
}

class _DokterScreenState extends State<DokterScreen> {
  List<Map<String, dynamic>> dokterList = [];
  List<Map<String, dynamic>> filteredDokterList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDokterList();
  }

  Future<void> _loadDokterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dokterString = prefs.getString('dokterList');
    if (dokterString != null) {
      setState(() {
        dokterList = List<Map<String, dynamic>>.from(json.decode(dokterString));
        filteredDokterList = List.from(dokterList);
      });
    }
  }

  Future<void> _saveDokterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dokterString = json.encode(dokterList);
    prefs.setString('dokterList', dokterString);
  }

  void _filterDokter(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDokterList = List.from(dokterList);
      } else {
        filteredDokterList = dokterList.where((dokter) {
          return dokter['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
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
          'Dokter',
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
                      hintText: 'Cari Dokter',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      _filterDokter(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDokterList.length,
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
                              dokterList.remove(deletedDokter);
                              filteredDokterList.remove(deletedDokter);
                              _saveDokterList();
                            });
                          },
                          onEditDokter: (editedDokter) {
                            setState(() {
                              int index = dokterList.indexWhere((dokter) => dokter['name'] == editedDokter['name']);
                              if (index != -1) {
                                dokterList[index] = editedDokter;
                                filteredDokterList[index] = editedDokter;
                                _saveDokterList();
                              }
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
                    // Cek apakah dokter dengan nama yang sama sudah ada
                    bool dokterExists = dokterList.any((dokter) => dokter['name'] == name);
                    if (!dokterExists) {
                      dokterList.add({
                        "name": name,
                        "photo": 'assets/images/doctor1.png',
                      });
                      filteredDokterList.add({
                        "name": name,
                        "photo": 'assets/images/doctor1.png',
                      });
                      _saveDokterList();
                    } else {
                      // Jika dokter sudah ada, tampilkan pesan atau lakukan hal lain
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dokter dengan nama yang sama sudah ada!')),
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