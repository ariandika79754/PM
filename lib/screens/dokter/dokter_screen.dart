import 'package:flutter/material.dart';

class DokterScreen extends StatefulWidget {
  @override
  _DokterScreenState createState() => _DokterScreenState();
}

class _DokterScreenState extends State<DokterScreen> {
  List<Map<String, dynamic>> dokterList = [];
  final TextEditingController _searchController = TextEditingController();

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
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Dokter',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      // Tambahkan logika pencarian jika diperlukan
                    },
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
                    backgroundImage: AssetImage(dokterList[index]['photo']),
                    radius: 30,
                  ),
                  title: Text('Nama Dokter: ${dokterList[index]['name']}'),
                  onTap: () {
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
                        });
                      },
                    )),
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nama Dokter', dokter['name']),
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
                  // Tambahkan logika edit dokter
                },
                icon: Icon(
                  Icons.edit,
                  size: 18,
                ),
                label: Text('Edit'),
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
                            Navigator.pop(context);
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Logika hapus dokter dari daftar
                          },
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 18,
                ),
                label: Text('Hapus'),
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
  final Function(String) onAddDokter;

  TambahDokterScreen({required this.onAddDokter});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Dokter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              onAddDokter(_nameController.text);
              Navigator.pop(context);
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
            _buildInputField(Icons.person, 'Nama Dokter', _nameController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller) {
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
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: label,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
