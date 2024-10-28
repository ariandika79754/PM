import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiwayatKunjunganScreen extends StatefulWidget {
  @override
  _RiwayatKunjunganScreenState createState() => _RiwayatKunjunganScreenState();
}

class _RiwayatKunjunganScreenState extends State<RiwayatKunjunganScreen> {
  List<Map<String, dynamic>> pasienList = [];
  String? loggedInUsername;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUsername(); // Load username saat inisialisasi
  }

  // Load username yang sedang login dari SharedPreferences
  Future<void> _loadLoggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUsername =
          prefs.getString('username'); // Ambil username dari SharedPreferences
    });
    _loadPasienList(); // Panggil untuk memuat data pasien setelah mendapatkan username
  }

  // Load daftar pasien dari SharedPreferences
  Future<void> _loadPasienList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pasienString = prefs.getString('pasienList');
    if (pasienString != null) {
      List<Map<String, dynamic>> allPasien =
          List<Map<String, dynamic>>.from(json.decode(pasienString));
      setState(() {
        // Filter pasien list berdasarkan username yang sedang login
        pasienList = allPasien
            .where((pasien) => pasien['username'] == loggedInUsername)
            .toList();
        print('Filtered Pasien List: $pasienList'); // Debugging
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kunjungan Pasien',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: pasienList.isNotEmpty
          ? ListView.builder(
              itemCount: pasienList.length,
              itemBuilder: (context, index) {
                final pasien = pasienList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama: ${pasien['name']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                            'Tanggal Kunjungan: ${pasien['tanggal'] ?? 'Belum ada kunjungan'}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Obat: ${pasien['obat'] ?? 'Tidak ada obat'}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('Tidak ada data pasien.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            ),
    );
  }
}
