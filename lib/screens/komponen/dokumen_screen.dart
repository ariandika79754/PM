import 'package:flutter/material.dart';
import '../dokter/dokter_screen.dart'; // Import halaman dokter
import '../obat/obat_screen.dart'; // Import halaman obat

class DokumenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan icon back
        title: Text('Dokumen'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 32.0), // Tambah padding kiri
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          mainAxisAlignment: MainAxisAlignment.start, // Atur ke bagian atas
          children: <Widget>[
            SizedBox(height: 50), // Tambah jarak dari atas layar
            // Baris untuk gambar dan teks Dokter
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman Dokter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DokterScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/doctor2.png'),
                    radius: 30, // Ukuran gambar
                  ),
                  SizedBox(width: 16), // Jarak antara gambar dan teks
                  Text(
                    'Dokter',
                    style: TextStyle(fontSize: 18), // Tambah ukuran font
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Jarak vertikal antara Dokter dan Obat
            // Baris untuk gambar dan teks Obat
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman Obat
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObatScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/obat1.png'),
                    radius: 30, // Ukuran gambar
                  ),
                  SizedBox(width: 16), // Jarak antara gambar dan teks
                  Text(
                    'Obat',
                    style: TextStyle(fontSize: 18), // Tambah ukuran font
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
