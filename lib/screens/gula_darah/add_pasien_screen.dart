import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

class AddPasienScreen extends StatefulWidget {
  final Map<String, dynamic>? pasienData; // Data pasien untuk di-edit

  AddPasienScreen({this.pasienData}); // Bisa null jika tambah baru

  @override
  _AddPasienScreenState createState() => _AddPasienScreenState();
}

class _AddPasienScreenState extends State<AddPasienScreen> {
  String? selectedStatus; // Store selected status
  bool showProdiJurusan =
      false; // Control visibility of Prodi and Jurusan fields
  DateTime? selectedDate; // To store the selected date
  TextEditingController dateController =
      TextEditingController(); // Controller for the date field

  // Controllers for text fields
  TextEditingController namaController = TextEditingController();
  TextEditingController prodiController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController gulaDarahController = TextEditingController();
  TextEditingController tensiController = TextEditingController();
  TextEditingController kolestrolController = TextEditingController();
  TextEditingController asamUratController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika ada data pasien, isi form dengan data tersebut
    if (widget.pasienData != null) {
      namaController.text = widget.pasienData!['nama'];
      dateController.text = widget.pasienData!['tanggal'];
      selectedStatus = widget.pasienData!['status'];
      showProdiJurusan = (selectedStatus == 'Mahasiswa');
      prodiController.text = widget.pasienData!['prodi'];
      jurusanController.text = widget.pasienData!['jurusan'];
      gulaDarahController.text = widget.pasienData!['gula_darah'];
      tensiController.text = widget.pasienData!['tensi'];
      kolestrolController.text = widget.pasienData!['kolestrol'];
      asamUratController.text = widget.pasienData!['asam_urat'];
      keteranganController.text = widget.pasienData!['keterangan'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pasienData == null ? 'Tambah Pasien' : 'Edit Pasien'),
        actions: [
          TextButton(
            onPressed: () {
              // Validasi sebelum menyimpan
              if (namaController.text.isEmpty ||
                  dateController.text.isEmpty ||
                  selectedStatus == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }

              // Data yang akan disimpan
              Map<String, dynamic> pasienData = {
                "nama": namaController.text,
                "tanggal": dateController.text,
                "status": selectedStatus,
                "prodi": prodiController.text,
                "jurusan": jurusanController.text,
                "keterangan": keteranganController.text,
                "gula_darah": gulaDarahController.text,
                "tensi": tensiController.text,
                "kolestrol": kolestrolController.text,
                "asam_urat": asamUratController.text,
              };

              // Return data to the previous screen
              Navigator.pop(context, pasienData);
            },
            child: Text(
              'Simpan',
              style: TextStyle(color: Colors.green),
            ),
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

              // Tanggal TextField with DatePicker
              _buildDateField(context),

              SizedBox(height: 10),
              _buildDropdownField(
                Icons.insert_drive_file,
                "Status",
                ["Pegawai", "Mahasiswa"],
                (value) {
                  setState(() {
                    selectedStatus = value;
                    showProdiJurusan = (value == "Mahasiswa");
                  });
                },
              ),
              SizedBox(height: 10),
              if (showProdiJurusan) ...[
                _buildTextField(prodiController, Icons.school, "Prodi"),
                SizedBox(height: 10),
                _buildTextField(jurusanController, Icons.school, "Jurusan"),
                SizedBox(height: 10),
              ],            
              _buildTextField(gulaDarahController, Icons.health_and_safety,
                  "Cek Gula Darah"),
              SizedBox(height: 10),
              _buildTextField(tensiController, Icons.monitor_heart, "Tensi"),
              SizedBox(height: 10),
              _buildTextField(kolestrolController, Icons.monitor_heart_outlined,
                  "Kolestrol"),
              SizedBox(height: 10),
              _buildTextField(asamUratController, Icons.warning, "Asam Urat"),
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
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Date field that opens a DatePicker
  Widget _buildDateField(BuildContext context) {
    return TextField(
      controller: dateController,
      readOnly: true, // So the keyboard doesn't appear
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today),
        labelText: 'Tanggal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
            dateController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate); // Format date
          });
        }
      },
    );
  }

  Widget _buildDropdownField(IconData icon, String label, List<String> items,
      ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
