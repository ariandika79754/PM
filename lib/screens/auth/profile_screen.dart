import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_register_selection.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load data profile saat inisialisasi
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? 'Poliklinik';
      _emailController.text =
          prefs.getString('email') ?? 'poliklinik@gmail.com';
      _passwordController.text = prefs.getString('password') ?? '12345678';
      _phoneController.text =
          prefs.getString('phone') ?? ''; // Load nomor telepon
    });
  }

  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Simpan data profil ke SharedPreferences
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('phone', _phoneController.text);

    // Tampilkan pesan berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil berhasil diubah')),
    );
  }

  Widget _buildEditableProfileItem(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green), // Icon hijau
          labelStyle: TextStyle(color: Colors.green),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.green, width: 2.0), // Border hijau
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green, width: 2.0), // Border hijau saat fokus
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan icon back
        title: Text('Profile'),
      ),
      body: SingleChildScrollView( // Menambahkan kemampuan scroll
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Menambahkan gambar klinik berbentuk lingkaran
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/klinik.jpg'),
              ),
              SizedBox(height: 20), // Spasi antara gambar dan kolom username
              _buildEditableProfileItem(
                  'Username', _usernameController, Icons.person),
              _buildEditableProfileItem(
                  'Password', _passwordController, Icons.lock),
              _buildEditableProfileItem(
                  'Email', _emailController, Icons.email),
              _buildEditableProfileItem(
                  'Nomor Telepon', _phoneController, Icons.phone),
              SizedBox(height: 20),
              // Tombol hijau untuk Update profil
              ElevatedButton(
                onPressed: _updateProfile, // Action untuk update profil
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Warna hijau untuk background tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Membuat tombol menjadi melengkung
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15), // Padding tombol
                ),
                child: Text(
                  'Update',
                  style:
                      TextStyle(color: Colors.white, fontSize: 16), // Teks putih
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.red),
                title: Text('Keluar'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginRegisterSelection()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
