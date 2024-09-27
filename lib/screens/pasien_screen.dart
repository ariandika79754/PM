import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal

class PasienScreen extends StatefulWidget {
  @override
  _PasienScreenState createState() => _PasienScreenState();
}

class _PasienScreenState extends State<PasienScreen> {
  List<Map<String, dynamic>> pasienList = [
    {
      "id": 1,
      "name": "Marisa Savina",
      "spesialis": "Demam",
      "alamat": "Bandar Lampung",
      "email": "marisa@gmail.com",
      "phone": "081234567890",
      "catatan": "Pasien dengan riwayat asma",
      "image": "assets/images/doctor1.png"
    },
    {
      "id": 2,
      "name": "Raihan Ardiansah",
      "spesialis": "Batuk Pilek",
      "alamat": "Bandar Lampung",
      "email": "raihan@gmail.com",
      "phone": "0892929191",
      "catatan": "-",
      "image": "assets/images/doctor3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Pasien',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pasienList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(pasienList[index]['image']),
                  ),
                  title: Text("No RM : ${pasienList[index]['id']}"),
                  subtitle: Text(pasienList[index]['name']),
                  onTap: () {
                    // Aksi saat pasien diklik, navigasi ke halaman detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPasienScreen(
                          pasien: pasienList[index],
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
          // Aksi saat tombol tambah pasien diklik
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahPasienScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasien;

  DetailPasienScreen({required this.pasien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pasien'),
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
            buildDetailRow('Nama', pasien['name']),
            SizedBox(height: 10),
            buildDetailRow('Spesialis', pasien['spesialis']),
            SizedBox(height: 10),
            buildDetailRow('Alamat', pasien['alamat']),
            SizedBox(height: 10),
            buildDetailRow('Email', pasien['email']),
            SizedBox(height: 10),
            buildDetailRow('Nomor Telepon', pasien['phone']),
            SizedBox(height: 10),
            buildDetailRow('Catatan', pasien['catatan']),
          ],
        ),
      ),
      // Add Bottom Navigation or a Custom Bottom Bar
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

  Widget buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(': $value'),
      ],
    );
  }
}

class TambahPasienScreen extends StatefulWidget {
  @override
  _TambahPasienScreenState createState() => _TambahPasienScreenState();
}

class _TambahPasienScreenState extends State<TambahPasienScreen> {
  final _nomorRmController = TextEditingController();
  final _namaController = TextEditingController();
  final _nomorTeleponController = TextEditingController();
  final _catatanController = TextEditingController();

  String? _selectedGolonganDarah;
  DateTime? _selectedTanggalLahir;

  // Format untuk menampilkan tanggal di TextField
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nomorRmController.dispose();
    _namaController.dispose();
    _nomorTeleponController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _selectTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedTanggalLahir) {
      setState(() {
        _selectedTanggalLahir = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pasien'),
        actions: [
          TextButton(
            onPressed: () {
              // Collect and process input data
              print("Nomor RM: ${_nomorRmController.text}");
              print("Nama: ${_namaController.text}");
              print(
                  "Tanggal Lahir: ${_dateFormat.format(_selectedTanggalLahir!)}");
              print("Golongan Darah: $_selectedGolonganDarah");
              print("Nomor Telepon: ${_nomorTeleponController.text}");
              print("Catatan: ${_catatanController.text}");

              // Aksi untuk menyimpan data pasien, bisa menggunakan setState atau database
              Navigator.pop(
                  context); // After saving, go back to previous screen
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
            _buildInputField(
                _nomorRmController, Icons.tag, 'Nomor Rekam Medis'),
            _buildInputField(_namaController, Icons.person, 'Nama Lengkap'),

            // Input Tanggal Lahir
            GestureDetector(
              onTap: () => _selectTanggalLahir(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                    labelText: 'Tanggal Lahir',
                    hintText: _selectedTanggalLahir == null
                        ? 'Pilih Tanggal'
                        : _dateFormat.format(_selectedTanggalLahir!),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),

            // Dropdown untuk Golongan Darah
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.bloodtype, color: Colors.green),
                  labelText: 'Golongan Darah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                value: _selectedGolonganDarah,
                items: ['A', 'B', 'AB', 'O'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGolonganDarah = newValue;
                  });
                },
              ),
            ),

            _buildInputField(
                _nomorTeleponController, Icons.phone, 'Nomor Telepon'),
            _buildInputField(_catatanController, Icons.note, 'Catatan'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
