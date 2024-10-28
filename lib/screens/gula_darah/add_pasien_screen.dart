import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddPasienScreen extends StatefulWidget {
  final Map<String, dynamic>? pasienData;
  final List<Map<String, dynamic>> alatList;

  AddPasienScreen({required this.alatList, this.pasienData});

  @override
  _AddPasienScreenState createState() => _AddPasienScreenState();
}

class _AddPasienScreenState extends State<AddPasienScreen> {
  String? _selectedAlat;
  String? _selectedStatus;
  bool showProdiJurusan = false;
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController prodiController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController gulaDarahController = TextEditingController();
  TextEditingController tensiController = TextEditingController();
  TextEditingController kolestrolController = TextEditingController();
  TextEditingController asamUratController = TextEditingController();

  String? _selectedProdi;
  String? _selectedJurusan;

  final Map<String, List<String>> _jurusanProdiMap = {
    'Budidaya Tanaman Pangan': [
      'Hortikultura',
      'Teknologi ProduksiTanamanPangan',
      'Teknologi Perbenihan',
      'TPT Hortikultura'
    ],
    'Budidaya Tanaman Perkebunan': [
      'Produksi Tanaman Perkebunan',
      'Produksi & Manajemen Induskebunan',
      'Pengelolaan Perkebunan Kopi'
    ],
  };

  Future<void> _loadAlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? alatListJson = prefs.getString('alatList');
    if (alatListJson != null) {
      List<dynamic> jsonList = json.decode(alatListJson);
      setState(() {
        widget.alatList.clear();
        widget.alatList.addAll(List<Map<String, dynamic>>.from(jsonList));
      });
    }
  }

  Future<void> _saveAlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String updatedAlatListJson = json.encode(widget.alatList);
    await prefs.setString('alatList', updatedAlatListJson);
  }

  void _reduceAlatStock() {
    if (_selectedAlat != null) {
      for (var alat in widget.alatList) {
        if (alat['name'] == _selectedAlat && (alat['stok'] ?? 0) > 0) {
          setState(() {
            alat['stok'] -= 1;
          });
          _saveAlatList(); // Simpan stok yang telah diperbarui ke SharedPreferences
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAlatList();

    if (widget.pasienData != null) {
      namaController.text = widget.pasienData!['nama'] ?? '';
      _selectedAlat = widget.pasienData!['alat_gula_darah'] ?? '';
      dateController.text = widget.pasienData!['tanggal'] ?? '';
      _selectedStatus = widget.pasienData!['status'] ?? '';
      showProdiJurusan = (_selectedStatus == 'Mahasiswa');
      prodiController.text = widget.pasienData!['prodi'] ?? '';
      jurusanController.text = widget.pasienData!['jurusan'] ?? '';
      gulaDarahController.text = widget.pasienData!['gula_darah'] ?? '';
      tensiController.text = widget.pasienData!['tensi'] ?? '';
      kolestrolController.text = widget.pasienData!['kolestrol'] ?? '';
      asamUratController.text = widget.pasienData!['asam_urat'] ?? '';
      keteranganController.text = widget.pasienData!['keterangan'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.pasienData == null ? 'Tambah Pasien' : 'Edit Pasien'),
        actions: [
          TextButton(
            onPressed: () {
              if (namaController.text.isEmpty ||
                  dateController.text.isEmpty ||
                  _selectedStatus == null ||
                  _selectedAlat == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }

              Map<String, dynamic> pasienData = {
                "nama": namaController.text,
                "tanggal": dateController.text,
                'alat_gula_darah': _selectedAlat,
                "status": _selectedStatus,
                "prodi": _selectedProdi,
                "jurusan": _selectedJurusan,
                "keterangan": keteranganController.text,
                "gula_darah": gulaDarahController.text,
                "tensi": tensiController.text,
                "kolestrol": kolestrolController.text,
                "asam_urat": asamUratController.text,
                "username":
                    namaController.text, // Menambahkan username otomatis
              };

              _reduceAlatStock(); // Kurangi stok alat saat menyimpan data
              Navigator.pop(context, pasienData);
            },
            child: Text('Simpan', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(namaController, Icons.person, "Nama Lengkap"),
              SizedBox(height: 10),
              _buildDateField(context),
              SizedBox(height: 10),
              _buildDropdownField(
                Icons.insert_drive_file,
                "Status",
                ["Pegawai", "Mahasiswa"],
                (value) {
                  setState(() {
                    _selectedStatus = value;
                    showProdiJurusan = (value == "Mahasiswa");
                    if (!showProdiJurusan) {
                      prodiController.clear();
                      jurusanController.clear();
                      _selectedProdi = null;
                      _selectedJurusan = null;
                    }
                  });
                },
                _selectedStatus,
              ),
              SizedBox(height: 10),
              if (showProdiJurusan) ...[
                _buildDropdownField(
                  Icons.school,
                  "Jurusan",
                  _jurusanProdiMap.keys.toList(),
                  (value) {
                    setState(() {
                      _selectedJurusan = value;
                      _selectedProdi = null;
                      prodiController.clear();
                    });
                  },
                  _selectedJurusan,
                ),
                SizedBox(height: 10),
                if (_selectedJurusan != null)
                  _buildDropdownField(
                    Icons.school,
                    "Prodi",
                    _jurusanProdiMap[_selectedJurusan] ?? [],
                    (value) {
                      setState(() {
                        _selectedProdi = value;
                      });
                    },
                    _selectedProdi,
                  ),
                SizedBox(height: 10),
              ],
              _buildDropdownAlatField(),
              SizedBox(height: 10),
              _buildTextField(gulaDarahController, Icons.health_and_safety,
                  "Cek Gula Darah"),
              SizedBox(height: 10),
              _buildTextField(tensiController, Icons.monitor_heart, "Tensi"),
              SizedBox(height: 10),
              _buildTextField(kolestrolController, Icons.monitor_heart_outlined,
                  "Kolestrol"),
              SizedBox(height: 10),
              _buildTextField(
                  asamUratController, Icons.monitor_heart, "Asam Urat"),
              SizedBox(height: 10),
              _buildTextField(keteranganController, Icons.note, "Keterangan"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextField(
      controller: dateController,
      decoration: InputDecoration(
        labelText: 'Tanggal',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );
  }

  Widget _buildDropdownField(IconData icon, String label, List<String> items,
      Function(String?) onChanged, String? selectedValue) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownAlatField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Alat Cek Gula Darah",
        border: OutlineInputBorder(),
      ),
      value: _selectedAlat,
      onChanged: (String? newValue) {
        setState(() {
          _selectedAlat = newValue;
        });
      },
      items: widget.alatList.map<DropdownMenuItem<String>>((alat) {
        return DropdownMenuItem<String>(
          value: alat['name'],
          child: Text(alat['name']),
        );
      }).toList(),
    );
  }
}
