import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo PUSKESLA
            Image.asset('assets/images/logo.png', height: 100), // Ganti dengan logo Anda
            SizedBox(height: 10),
            // Teks PUSKESLA
            Text(
              'PUSKESLA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Warna hijau pada teks PUSKESLA
              ),
            ),
            SizedBox(height: 30),
            // Input Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Masukkan Email',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.black, // Outline warna hitam
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tombol Kirim Email
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika kirim email untuk reset password di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Instruksi reset password telah dikirim ke email Anda')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Warna hijau untuk tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Kirim Email',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
