import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../komponen/home_screen.dart'; // Halaman Home untuk staff
import '../komponen/home_pasien_screen.dart'; // Halaman Home untuk pasien
import '../komponen/forgot_password_screen.dart'; // Halaman lupa password

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _saveDefaultStaffAccount();
  }

  // Fungsi untuk menyimpan akun default staff di SharedPreferences jika belum ada
  Future<void> _saveDefaultStaffAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Periksa apakah akun staff default sudah ada
    String? savedUsername = prefs.getString('staff_username');

    // Jika akun staff belum ada, maka tambahkan akun default
    if (savedUsername == null) {
      prefs.setString('staff_username', 'klinikpolinela');
      prefs.setString('staff_email', 'klinikpolinela.ac.id');
      prefs.setString('staff_password', 'klinikpolinela123');
      prefs.setString('staff_role', 'staff');
    }
  }

  // Fungsi untuk login
  Future<void> login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil data pengguna yang tersimpan
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');
    String? savedRole = prefs.getString('role'); // Ambil role pengguna pasien

    // Ambil data akun staff
    String? staffUsername = prefs.getString('staff_username');
    String? staffPassword = prefs.getString('staff_password');

    // Verifikasi login
    if ((usernameController.text == savedUsername &&
            passwordController.text == savedPassword) ||
        (usernameController.text == staffUsername &&
            passwordController.text == staffPassword)) {
      // Jika login berhasil, periksa role
      if (usernameController.text == staffUsername) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Halaman staff
        );
      } else if (savedRole == 'pasien') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePasienScreen()), // Halaman pasien
        );
      }
    } else {
      // Jika akun tidak ditemukan atau salah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Akun Anda belum terdaftar atau username dan password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              SizedBox(height: 10),
              Text(
                'PUSKESLA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Arahkan ke halaman lupa password
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Lupa Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
