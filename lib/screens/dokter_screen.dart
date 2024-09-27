import 'package:flutter/material.dart';

class DokterScreen extends StatefulWidget {
  @override
  _DokterScreenState createState() => _DokterScreenState();
}

class _DokterScreenState extends State<DokterScreen> {
  List<Map<String, dynamic>> dokterList = [
    {
      "name": "Raihan Ardiansah",
      "spesialis": "Batuk Pilek",
      "alamat": "Bandar Lampung",
      "email": "Raihan@gmail.com",
      "nomor_telepon": "0892929191",
      "catatan": "-",
      "image": "assets/images/doctor1.png"
    },
    {
      "name": "Amanda",
      "spesialis": "Tipes",
      "alamat": "Bandar Lampung",
      "email": "amanda@gmail.com",
      "nomor_telepon": "085711223344",
      "catatan": "-",
      "image": "assets/images/doctor2.png"
    },
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
        title: Text('Dokter'),
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
                      hintText: 'Search Dokter',
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
              itemCount: dokterList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(dokterList[index]['image']),
                    radius: 30,
                  ),
                  title: Text('Nama Dokter: ${dokterList[index]['name']}'),
                  subtitle:
                      Text('Spesialis: ${dokterList[index]['spesialis']}'),
                  onTap: () {
                    // Navigasi ke halaman detail dokter saat item diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDokterScreen(
                          dokter: dokterList[index],
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
          // Aksi untuk tombol tambah dokter
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahDokterScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetailDokterScreen extends StatelessWidget {
  final Map<String, dynamic> dokter;

  DetailDokterScreen({required this.dokter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Dokter'),
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
            _buildDetailRow('Nama Dokter', dokter['name']),
            _buildDetailRow('Spesialis', dokter['spesialis']),
            _buildDetailRow('Alamat', dokter['alamat']),
            _buildDetailRow('Email', dokter['email']),
            _buildDetailRow('Nomor Telepon', dokter['nomor_telepon']),
            _buildDetailRow('Catatan', dokter['catatan']),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahDokterScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  size: 18, // Mengurangi ukuran icon
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14, // Mengurangi ukuran font
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8), // Mengurangi padding
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Hapus Dokter'),
                      content:
                          Text('Apakah Anda yakin ingin menghapus dokter ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Tutup dialog
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Tutup dialog
                            Navigator.pop(
                                context); // Kembali ke halaman sebelumnya
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 18, // Mengurangi ukuran icon
                ),
                label: Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 14, // Mengurangi ukuran font
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8), // Mengurangi padding
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(': $value'),
        ],
      ),
    );
  }
}

class TambahDokterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Dokter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Aksi untuk menyimpan data dokter
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
            _buildInputField(Icons.person, 'Nama Dokter'),
            _buildInputField(Icons.medical_services, 'Spesialis'),
            _buildInputField(Icons.location_on, 'Alamat'),
            _buildInputField(Icons.email, 'Email'),
            _buildInputField(Icons.phone, 'Nomor Telepon'),
            _buildInputField(Icons.note, 'Catatan'),
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
