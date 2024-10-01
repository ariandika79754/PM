import 'package:flutter/material.dart';
import 'login_register_selection.dart'; // Import halaman login/register

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan icon back
        title: Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Action untuk update profil
            },
            child: Text(
              'Update',
              style: TextStyle(
                  color: Colors.green, fontSize: 14), // ukuran font lebih kecil
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Mengurangi padding keseluruhan
        child: Column(
          children: [
            _buildProfileItem(Icons.person, 'Raihan Ardiansah'),
            _buildProfileItem(Icons.lock, '12345678'),
            _buildProfileItem(Icons.email, 'Raihan@Gmail.Com'),
            _buildProfileItem(Icons.calendar_today, '06-03-2000'),
            _buildProfileItem(Icons.transgender, 'Laki-Laki'),
            _buildProfileItem(Icons.location_on, 'Jl. Raja Basa Maju Mundur'),
            _buildProfileItem(Icons.phone, '089201019293'),
            SizedBox(height: 10), // Mengurangi jarak antar elemen
            _buildProfileItem(Icons.exit_to_app, 'Keluar',
                isLogout: true, context: context), // Tambah context
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text,
      {bool isLogout = false, BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6.0), // Mengurangi jarak vertikal antar item
      child: GestureDetector(
        onTap: isLogout
            ? () {
                // Pindah ke halaman LoginRegisterSelection saat klik 'Keluar'
                Navigator.pushReplacement(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => LoginRegisterSelection(),
                  ),
                );
              }
            : null, // Tidak ada aksi untuk item lain
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.green, width: 1.5), // Lebar border lebih tipis
            borderRadius: BorderRadius.circular(
                20), // Radius lebih kecil agar lebih ringkas
          ),
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: 12), // Mengurangi padding dalam item
          child: Row(
            children: [
              Icon(icon,
                  color: Colors.green, size: 20), // Ukuran icon lebih kecil
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14, // Ukuran teks lebih kecil
                    fontWeight: FontWeight.w500,
                    color: isLogout ? Colors.red : Colors.black,
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
