import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

class AddPasienScreen extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pasien'),
        actions: [
          TextButton(
            onPressed: () {
              // Logic to save data when the Save button is pressed
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
              _buildTextField(keteranganController, Icons.note, "Keterangan"),
              SizedBox(height: 10),
              _buildTextField(gulaDarahController, Icons.health_and_safety,
                  "Cek Gula Darah"),
              SizedBox(height: 10),
              _buildTextField(tensiController, Icons.monitor_heart, "Tensi"),
              SizedBox(height: 10),
              _buildTextField(kolestrolController, Icons.monitor_heart_outlined,
                  "Kolestrol"),
              SizedBox(height: 10),
              _buildTextField(asamUratController, Icons.warning, "Asam Urat"),
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
