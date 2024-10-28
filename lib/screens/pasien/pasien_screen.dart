import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tambah_pasien_screen.dart';
import 'detail_pasien_screen.dart';

class PasienScreen extends StatefulWidget {
  @override
  _PasienScreenState createState() => _PasienScreenState();
}

class _PasienScreenState extends State<PasienScreen> {
  List<Map<String, dynamic>> pasienList = [];
  List<Map<String, dynamic>> obatList = [];
  List<Map<String, dynamic>> dokterList = [];
  List<Map<String, dynamic>> filteredPasienList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPasienList();
    _loadObatList();
    _loadDokterList();

    _searchController.addListener(_filterPasienList);
  }

  Future<void> _loadPasienList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pasienString = prefs.getString('pasienList');
    if (pasienString != null) {
      setState(() {
        pasienList = List<Map<String, dynamic>>.from(json.decode(pasienString));
        filteredPasienList = pasienList;
      });
    }
  }

  Future<void> _loadObatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? obatString = prefs.getString('obatList');
    if (obatString != null) {
      setState(() {
        obatList = List<Map<String, dynamic>>.from(json.decode(obatString));
      });
    }
  }

  Future<void> _loadDokterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dokterString = prefs.getString('dokterList');
    if (dokterString != null) {
      setState(() {
        dokterList = List<Map<String, dynamic>>.from(json.decode(dokterString));
      });
    }
  }

  void _addPasien(Map<String, dynamic> pasienBaru) {
    setState(() {
      pasienList.add(pasienBaru);
      filteredPasienList = pasienList;
      _savePasienList();
    });
  }

  void _updatePasien(Map<String, dynamic> updatedPasien) {
    setState(() {
      int index = pasienList.indexWhere((p) =>
          p['id'] == updatedPasien['id']); // Ganti 'id' dengan atribut unik
      if (index != -1) {
        pasienList[index] = updatedPasien;
      }
      filteredPasienList = pasienList;
      _savePasienList();
    });
  }

  void _savePasienList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pasienString = json.encode(pasienList);
    prefs.setString('pasienList', pasienString);
  }

  void _deletePasien(Map<String, dynamic> pasienToDelete) {
    setState(() {
      pasienList.remove(pasienToDelete);
      filteredPasienList = pasienList;
      _savePasienList();
    });
  }

  void _filterPasienList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredPasienList = pasienList
          .where((pasien) => pasien['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  String _getPatientPhoto(String status) {
    if (status == 'mahasiswa') {
      return 'assets/images/mahasiswa.png';
    } else {
      return 'assets/images/staff.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Daftar Pasien',
          style: TextStyle(
            fontSize: 32, // Ukuran font
            fontFamily: 'Times New Roman', // Font Latin
            color: Colors.green, // Warna hijau
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama pasien...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 195, 194, 194),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredPasienList.length,
        itemBuilder: (context, index) {
          final pasien = filteredPasienList[index];
          final status = pasien['status'] ?? 'pegawai';
          final photoPath = _getPatientPhoto(status);

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(photoPath),
            ),
            title: Text(pasien['name']),
            subtitle: Text(pasien['obat'] ?? 'No Obat'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPasienScreen(
                    pasien: pasien,
                    onDelete: (deletedPasien) {
                      _deletePasien(deletedPasien);
                    },
                    onUpdate: (updatedPasien) {
                      _updatePasien(updatedPasien); // Update pasien
                    },
                  ),
                ),
              );

              if (result == true) {
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahPasienScreen(
                onAddPasien: _addPasien,
                obatList: obatList,
                dokterList: dokterList,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
