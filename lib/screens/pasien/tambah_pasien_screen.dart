import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TambahPasienScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddPasien;
  final Map<String, dynamic>? pasien;
  final List<Map<String, dynamic>> obatList; // Daftar obat
  final List<Map<String, dynamic>> dokterList; // Daftar dokter

  TambahPasienScreen(
      {required this.onAddPasien,
      this.pasien,
      required this.obatList,
      required this.dokterList});

  @override
  _TambahPasienScreenState createState() => _TambahPasienScreenState();
}

class _TambahPasienScreenState extends State<TambahPasienScreen> {
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _diagnosaController = TextEditingController();
  final _catatanController = TextEditingController();
  final _jumlahObatController = TextEditingController();
  final _selectedProdiController = TextEditingController();

  String? _selectedObat;
  String? _selectedDokter;
  String? _status = "pegawai"; // Default status
  String? _selectedProdi;
  String? _selectedJurusan;

  final List<String> _prodiOptions = [
    'TI (Teknologi Informasi)',
    'ekbis',
    'kebun',
    'ternak',
    'perkap'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pasien != null) {
      _namaController.text = widget.pasien!['name'];
      _umurController.text = widget.pasien!['umur'];
      _diagnosaController.text = widget.pasien!['diagnosa'];
      _catatanController.text = widget.pasien!['catatan'];
      _selectedObat = widget.pasien!['obat'];
      _selectedDokter = widget.pasien!['dokter'];
      _jumlahObatController.text = widget.pasien!['jumlah_obat'] ?? '';
      _status = widget.pasien!['status'] ?? 'pegawai'; // Ambil status jika ada
      _selectedProdi = widget.pasien!['prodi'];
      _selectedJurusan = widget.pasien!['jurusan'];
    }
  }

  void _savePasien() async {
    Map<String, dynamic> pasienBaru = {
      'name': _namaController.text,
      'umur': _umurController.text,
      'diagnosa': _diagnosaController.text,
      'catatan': _catatanController.text,
      'obat': _selectedObat,
      'jumlah_obat': _jumlahObatController.text,
      'dokter': _selectedDokter,
      'status': _status,
      'tanggal': DateTime.now().toString(), // Tambahkan tanggal saat ini
      if (_status == 'mahasiswa') 'prodi': _selectedProdi,
      if (_status == 'mahasiswa') 'jurusan': _selectedJurusan,
    };

    // Kurangi stok obat
    await _reduceObatStock();

    widget.onAddPasien(pasienBaru);
    Navigator.pop(context);
  }

  Future<void> _reduceObatStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? obatString = prefs.getString('obatList');
    if (obatString != null) {
      List<Map<String, dynamic>> obatList =
          List<Map<String, dynamic>>.from(json.decode(obatString));

      // Cari obat yang dipilih dan kurangi stoknya
      for (var obat in obatList) {
        if (obat['name'] == _selectedObat) {
          int currentStock = obat['stok'];
          int quantity = int.tryParse(_jumlahObatController.text) ?? 0;
          obat['stok'] = (currentStock - quantity)
              .clamp(0, currentStock); // Pastikan stok tidak negatif
          break;
        }
      }

      // Simpan kembali daftar obat yang telah diperbarui
      String updatedObatString = json.encode(obatList);
      prefs.setString('obatList', updatedObatString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pasien != null ? 'Update Pasien' : 'Tambah Pasien'),
        actions: [
          TextButton(
            onPressed: _savePasien,
            child: Text('Simpan',
                style: TextStyle(color: Colors.green, fontSize: 16)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                _buildInputField(_namaController, Icons.person, 'Nama Lengkap'),
                _buildInputField(_umurController, Icons.calendar_today, 'Umur'),
                _buildInputField(
                    _diagnosaController, Icons.local_hospital, 'Diagnosa'),

                // Dropdown untuk status
                _buildDropdown(['pegawai', 'mahasiswa'], _status, 'Pilih Status',
                    (newValue) {
                  setState(() {
                    _status = newValue;
                  });
                }),

                // Tampilkan dropdown prodi dan jurusan jika status mahasiswa
                if (_status == 'mahasiswa') ...[
                  _buildInputField(
                      _selectedProdiController, Icons.school, 'Prodi'),
                  _buildDropdown(_prodiOptions, _selectedJurusan, 'Pilih Jurusan',
                      (newValue) {
                    setState(() {
                      _selectedJurusan = newValue;
                    });
                  }),
                ],

                // Dropdown untuk obat dengan tambahan opsi "-"
                _buildDropdown(
                    ['-'] +
                        widget.obatList
                            .map((obat) => obat['name'].toString())
                            .toList(),
                    _selectedObat,
                    'Pilih Obat', (newValue) {
                  setState(() {
                    _selectedObat = newValue;
                  });
                }),

                _buildInputField(_jumlahObatController, Icons.confirmation_number,
                    'Jumlah Obat'),
                _buildDropdown(
                    ['-'] +
                        widget.dokterList
                            .map((dokter) => dokter['name'].toString())
                            .toList(),
                    _selectedDokter,
                    'Pilih Dokter', (newValue) {
                  setState(() {
                    _selectedDokter = newValue;
                  });
                }),
                _buildInputField(_catatanController, Icons.note, 'Catatan'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Kurangi padding
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

  Widget _buildDropdown(List<String> items, String? selectedItem, String hint,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Kurangi padding
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        ),
        value: selectedItem,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
