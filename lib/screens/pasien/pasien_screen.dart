import 'package:flutter/material.dart';

class PasienScreen extends StatefulWidget {
  @override
  _PasienScreenState createState() => _PasienScreenState();
}

class _PasienScreenState extends State<PasienScreen> {
  List<Map<String, dynamic>> pasienList = [];

  void _addPasien(Map<String, dynamic> pasienBaru) {
    setState(() {
      pasienList.add(pasienBaru);
    });
  }

  void _updatePasien(int index, Map<String, dynamic> pasienUpdated) {
    setState(() {
      pasienList[index] = pasienUpdated;
    });
  }

  void _deletePasien(int index) {
    setState(() {
      pasienList.removeAt(index);
    });
  }

  Future<void> _confirmDelete(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda ingin menghapus data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm) {
      _deletePasien(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Pasien',
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
                  title: Text("No RM : ${index + 1}"),
                  subtitle: Text(pasienList[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPasienScreen(
                          pasien: pasienList[index],
                          index: index,
                          onUpdatePasien: _updatePasien,
                          onDeletePasien: _confirmDelete,
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
              builder: (context) => TambahPasienScreen(
                onAddPasien: _addPasien,
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

class DetailPasienScreen extends StatelessWidget {
  final Map<String, dynamic> pasien;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdatePasien;
  final Function(int) onDeletePasien;

  DetailPasienScreen({
    required this.pasien,
    required this.index,
    required this.onUpdatePasien,
    required this.onDeletePasien,
  });

  void _printPasien() {
    print("Detail Pasien:");
    print("Nama: ${pasien['name']}");
    print("Umur: ${pasien['umur']}");
    print("Diagnosa: ${pasien['diagnosa']}");
    print("Status: ${pasien['status']}");
    if (pasien['status'] == 'Mahasiswa') {
      print("Prodi: ${pasien['prodi']}");
      print("Jurusan: ${pasien['jurusan']}");
    }
    print("Catatan: ${pasien['catatan']}");
    print("Konsultasi: ${pasien['konsultasi'] ?? 'Tidak Diketahui'}");
    if (pasien['konsultasi'] == 'Umum') {
      print("Obat: ${pasien['obat'] ?? 'Tidak Diketahui'}");
      print("Jumlah Obat: ${pasien['jumlah_obat'] ?? 'Tidak Diketahui'}");
    } else if (pasien['konsultasi'] == 'Spesialis') {
      print("Obat: ${pasien['obat'] ?? 'Tidak Diketahui'}");
      print("Jumlah Obat: ${pasien['jumlah_obat'] ?? 'Tidak Diketahui'}");
      print("Dokter: ${pasien['dokter'] ?? 'Tidak Diketahui'}");
    }
  }

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
            buildDetailRow('Nama     :', pasien['name'] ?? 'Tidak Diketahui'),
            SizedBox(height: 10),
            buildDetailRow('Umur     :', pasien['umur'] ?? 'Tidak Diketahui'),
            SizedBox(height: 10),
            buildDetailRow(
                'Diagnosa :', pasien['diagnosa'] ?? 'Tidak Diketahui'),
            SizedBox(height: 10),
            buildDetailRow('Status :', pasien['status'] ?? 'Tidak Diketahui'),
            if (pasien['status'] == 'Mahasiswa') ...[
              SizedBox(height: 10),
              buildDetailRow('Prodi :', pasien['prodi'] ?? 'Tidak Diketahui'),
              SizedBox(height: 10),
              buildDetailRow(
                  'Jurusan :', pasien['jurusan'] ?? 'Tidak Diketahui'),
            ],
            SizedBox(height: 10),
            buildDetailRow('Catatan :', pasien['catatan'] ?? 'Tidak Diketahui'),
            SizedBox(height: 10),
            buildDetailRow(
                'Konsultasi :', pasien['konsultasi'] ?? 'Tidak Diketahui'),
            if (pasien['konsultasi'] == 'Umum') ...[
              buildDetailRow('Obat :', pasien['obat'] ?? 'Tidak Diketahui'),
              buildDetailRow(
                  'Jumlah Obat :', pasien['jumlah_obat'] ?? 'Tidak Diketahui'),
            ] else if (pasien['konsultasi'] == 'Spesialis') ...[
              buildDetailRow('Obat', pasien['obat'] ?? 'Tidak Diketahui'),
              buildDetailRow(
                  'Jumlah Obat', pasien['jumlah_obat'] ?? 'Tidak Diketahui'),
              buildDetailRow('Dokter', pasien['dokter'] ?? 'Tidak Diketahui'),
            ],
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnPrint",
            onPressed: () {
              _printPasien(); // Mencetak data ke konsol
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data pasien dicetak ke konsol')),
              );
            },
            child: Icon(Icons.print),
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnEdit",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahPasienScreen(
                    onAddPasien: (updatedPasien) {
                      onUpdatePasien(index, updatedPasien);
                      Navigator.pop(context); // Kembali ke halaman detail
                    },
                    pasien: pasien,
                  ),
                ),
              );
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.orange,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnDelete",
            onPressed: () {
              onDeletePasien(index);
              Navigator.pop(context); // Kembali setelah hapus
            },
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start, // Memastikan elemen mulai dari kiri
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10), // Tambahkan sedikit ruang antara title dan value
        Expanded(
          // Menggunakan Expanded untuk nilai
          child: Text(
            value,
            overflow: TextOverflow.ellipsis, // Memastikan teks tidak overflow
          ),
        ),
      ],
    );
  }
}

class TambahPasienScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddPasien;
  final Map<String, dynamic>? pasien;

  TambahPasienScreen({required this.onAddPasien, this.pasien});

  @override
  _TambahPasienScreenState createState() => _TambahPasienScreenState();
}

class _TambahPasienScreenState extends State<TambahPasienScreen> {
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _diagnosaController = TextEditingController();
  final _catatanController = TextEditingController();
  final _prodiController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _obatController = TextEditingController();
  final _jumlahObatController = TextEditingController();
  final _dokterController = TextEditingController();

  String? _selectedStatus;
  String? _selectedKonsultasi;
  bool isMahasiswa = false;

  @override
  void initState() {
    super.initState();
    if (widget.pasien != null) {
      _namaController.text = widget.pasien!['name'];
      _umurController.text = widget.pasien!['umur'];
      _diagnosaController.text = widget.pasien!['diagnosa'];
      _catatanController.text = widget.pasien!['catatan'];
      _selectedStatus = widget.pasien!['status'];
      isMahasiswa = _selectedStatus == 'Mahasiswa';
      if (isMahasiswa) {
        _prodiController.text = widget.pasien!['prodi'];
        _jurusanController.text = widget.pasien!['jurusan'];
      }
      _selectedKonsultasi = widget.pasien!['konsultasi'];
      _obatController.text = widget.pasien!['obat'] ?? '';
      _jumlahObatController.text = widget.pasien!['jumlah_obat'] ?? '';
      _dokterController.text = widget.pasien!['dokter'] ?? '';
    }
  }

  void _savePasien() {
    String imagePath =
        isMahasiswa ? 'assets/images/doctor2.png' : 'assets/images/doctor3.png';

    Map<String, dynamic> pasienBaru = {
      'name': _namaController.text,
      'umur': _umurController.text,
      'diagnosa': _diagnosaController.text,
      'status': _selectedStatus,
      'prodi': isMahasiswa ? _prodiController.text : '',
      'jurusan': isMahasiswa ? _jurusanController.text : '',
      'catatan': _catatanController.text,
      'konsultasi': _selectedKonsultasi,
      'obat': _obatController.text,
      'jumlah_obat': _jumlahObatController.text,
      'dokter':
          _selectedKonsultasi == 'Spesialis' ? _dokterController.text : '',
      'image': imagePath,
    };

    widget.onAddPasien(pasienBaru);
    Navigator.pop(context); // Kembali setelah menyimpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pasien != null ? 'Update Pasien' : 'Tambah Pasien'),
        actions: [
          TextButton(
            onPressed: () {
              _savePasien();
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
            _buildInputField(_namaController, Icons.person, 'Nama Lengkap'),
            _buildInputField(_umurController, Icons.calendar_today, 'Umur'),
            _buildInputField(
                _diagnosaController, Icons.local_hospital, 'Diagnosa'),

            // Dropdown untuk Status
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.verified_user, color: Colors.green),
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                value: _selectedStatus,
                items: ['Pegawai', 'Mahasiswa'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                    isMahasiswa = newValue == 'Mahasiswa';
                  });
                },
              ),
            ),

            // Jika status adalah Mahasiswa, tampilkan kolom Prodi dan Jurusan
            if (isMahasiswa) ...[
              _buildInputField(_prodiController, Icons.school, 'Prodi'),
              _buildInputField(_jurusanController, Icons.business, 'Jurusan'),
            ],

            // Dropdown untuk Konsultasi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.assignment, color: Colors.green),
                  labelText: 'Konsultasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                value: _selectedKonsultasi,
                items: ['Umum', 'Spesialis'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedKonsultasi = newValue;
                  });
                },
              ),
            ),

            // Jika konsultasi adalah Umum, tampilkan kolom Obat dan Jumlah Obat
            if (_selectedKonsultasi == 'Umum') ...[
              _buildInputField(_obatController, Icons.medical_services, 'Obat'),
              _buildInputField(_jumlahObatController, Icons.confirmation_number,
                  'Jumlah Obat'),
            ]
            // Jika konsultasi adalah Spesialis, tampilkan kolom Obat, Jumlah Obat dan Dokter
            else if (_selectedKonsultasi == 'Spesialis') ...[
              _buildInputField(_obatController, Icons.medical_services, 'Obat'),
              _buildInputField(_jumlahObatController, Icons.confirmation_number,
                  'Jumlah Obat'),
              _buildInputField(_dokterController, Icons.person, 'Dokter'),
            ],

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
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
