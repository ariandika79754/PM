import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class TambahPasienScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddPasien;
  final Map<String, dynamic>? pasien;
  final List<Map<String, dynamic>> obatList; // Daftar obat
  final List<Map<String, dynamic>> dokterList; // Daftar dokter

  TambahPasienScreen({
    required this.onAddPasien,
    this.pasien,
    required this.obatList,
    required this.dokterList,
  });

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
  String? _status; // Tidak ada default value untuk status
  String? _selectedProdi;
  String? _selectedJurusan;

  final Map<String, List<String>> _jurusanProdiMap = {
    'Budidaya Tanaman Pangan': [
      'Hortikultura',
      'Teknologi Produksi Tanaman Pangan',
      'Teknologi Perbenihan',
      'TPT Hortikultura'
    ],
    'Budidaya Tanaman Perkebunan': [
      'Produksi Tanaman Perkebunan',
      'Produksi & Manajemen Induskebunan',
      'Pengelolaan Perkebunan Kopi'
    ],
    'Teknologi Pertanian': [
      'Pengolahan Patiseri',
      'Mekanisasi Pertanian',
      'Teknologi Pangan',
      'Pengembangan Produk Agroindustri',
      'Kimia Terapan'
    ],
    'Peternakan': [
      'Teknologi Produksi Ternak',
      'Agribisnis Peternakan',
      'Teknologi Pakan Ternak'
    ],
    'Ekonomi dan Bisnis': [
      'Perjalanan Wisata',
      'Agribisnis Pangan',
      'Pengelolaan Agribisnis',
      'Akuntansi Perpajakan',
      'Akuntansi Bisnis Digital',
      'Pengelolaan Perhotelan',
      'Pengelolaan Konvensi dan Acara'
    ],
    'Teknik': [
      'Teknik Sumberdaya Lahan dan Lingkungan',
      'Teknologi Rekayasa Konstruksi Jalan dan Jembatan',
      'Teknologi Rekayasa Kimia Industri'
    ],
    'Perikanan dan Kelautan': [
      'Budidaya Perikanan',
      'Perikanan Tangkap',
      'Teknologi Pembenihan Ikan'
    ],
    'Teknologi Informasi': [
      'Manajemen Informatika',
      'Teknologi Rekayasa Internet',
      'Teknologi Rekayasa Elektronika',
      'Teknologi Rekayasa Perangkat Lunak'
    ],
  };
  void _onJurusanChanged(String? newValue) {
    setState(() {
      _selectedJurusan = newValue;
      _selectedProdi = null; // Reset pilihan prodi jika jurusan berubah
    });
  }

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
      _status = widget.pasien!['status'];
      _selectedProdi = widget.pasien!['prodi'];
      _selectedJurusan = widget.pasien!['jurusan'];
    }
  }

  void _savePasien() async {
    if (_status == null) {
      // Beri notifikasi atau validasi jika status belum dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih status pasien terlebih dahulu')),
      );
      return;
    }

    String formattedDate =
        DateFormat('yyyy-MM-dd, HH.mm').format(DateTime.now());

    Map<String, dynamic> pasienBaru = {
      'name': _namaController.text,
      'umur': _umurController.text,
      'diagnosa': _diagnosaController.text,
      'catatan': _catatanController.text,
      'obat': _selectedObat,
      'jumlah_obat': _jumlahObatController.text,
      'dokter': _selectedDokter,
      'status': _status,
      'tanggal': '$formattedDate', // Format tanggal dan jam
      if (_status == 'mahasiswa') 'prodi': _selectedProdi,
      if (_status == 'mahasiswa') 'jurusan': _selectedJurusan,
      'username': _namaController.text, // Tambahkan username di sini
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
                _buildDropdown(
                    ['pegawai', 'mahasiswa'], _status, 'Pilih Status',
                    (newValue) {
                  setState(() {
                    _status = newValue;
                  });
                }),

                // Tampilkan dropdown prodi dan jurusan jika status mahasiswa
                if (_status == 'mahasiswa') ...[
                  _buildDropdown(
                    _jurusanProdiMap.keys.toList(),
                    _selectedJurusan,
                    'Pilih Jurusan',
                    _onJurusanChanged,
                  ),
                  if (_selectedJurusan != null)
                    _buildDropdown(
                      _jurusanProdiMap[_selectedJurusan!] ?? [],
                      _selectedProdi,
                      'Pilih Prodi',
                      (newValue) {
                        setState(() {
                          _selectedProdi = newValue;
                        });
                      },
                    ),
                ],

                // Dropdown untuk obat
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

                _buildInputField(_jumlahObatController,
                    Icons.confirmation_number, 'Jumlah Obat'),
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
