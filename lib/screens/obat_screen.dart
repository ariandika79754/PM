import 'package:flutter/material.dart';

class ObatScreen extends StatefulWidget {
  @override
  _ObatScreenState createState() => _ObatScreenState();
}

class _ObatScreenState extends State<ObatScreen> {
  List<Map<String, dynamic>> obatList = [
    {
      "name": "Paracetamol",
      "stok": 100,
      "keterangan": "500 mg",
      "image": "assets/images/obat1.png"
    },
    // Tambahkan daftar obat lain jika ada
  ];

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
                    // Navigasi ke halaman detail obat saat item diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailObatScreen(
                          obat: obatList[index],
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
          // Aksi untuk tombol tambah obat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahObatScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetailObatScreen extends StatelessWidget {
  final Map<String, dynamic> obat;

  DetailObatScreen({required this.obat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
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
              iconSize: 20, // Ukuran lebih kecil
              onPressed: () {
                // Aksi edit
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              iconSize: 20, // Ukuran lebih kecil
              onPressed: () {
                // Aksi delete
              },
            ),
            IconButton(
              icon: Icon(Icons.print, color: Colors.black),
              iconSize: 20, // Ukuran lebih kecil
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

class TambahObatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Obat'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Aksi untuk menyimpan data obat
            },
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
            _buildInputField(Icons.medical_services, 'Nama Obat'),
            _buildInputField(Icons.bookmark, 'Stok'),
            _buildInputField(Icons.description, 'Keterangan'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
