import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart'; // Pastikan rute untuk login screen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Untuk mengatur visibilitas password

  @override
  void initState() {
    super.initState();
    _loadStaffProfile();
  }

  // Fungsi untuk memuat data profil staff dari SharedPreferences
  Future<void> _loadStaffProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? staffUsername = prefs.getString('staff_username');
    String? staffEmail = prefs.getString('staff_email');
    String? staffPhone = prefs.getString('staff_phone');
    String? staffPassword = prefs.getString('staff_password');

    setState(() {
      usernameController.text = staffUsername ?? '';
      emailController.text = staffEmail ?? '';
      phoneController.text = staffPhone ?? '';
      passwordController.text = staffPassword ?? '';
    });
  }

  // Fungsi untuk menyimpan perubahan profil staff
  Future<void> _updateStaffAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('staff_username', usernameController.text);
    await prefs.setString('staff_email', emailController.text);
    await prefs.setString(
        'staff_phone', phoneController.text); // Simpan nomor telepon
    await prefs.setString('staff_password', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil staff berhasil diperbarui')),
    );
  }

  // Fungsi untuk keluar (logout)
  Future<void> _logout() async {
    // Hapus semua data yang tersimpan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Kembali ke login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 28, // Ukuran font
            fontFamily: 'Times New Roman', // Font Latin
            color: Colors.green, // Warna hijau
          ),
        ),

        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/klinik.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Staff Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Ubah warna teks sesuai keinginan
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Username',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter Username',
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter Email',
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Phone Number',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter Phone Number',
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Password',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText:
                    !_isPasswordVisible, // Kontrol visibilitas password
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updateStaffAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Sesuaikan warna tombol
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Warna tombol logout
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Keluar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
