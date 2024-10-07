import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/komponen/custom_bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sidebar_menu.dart';
import '../pasien/pasien_screen.dart'; // Import PasienScreen
import 'dokumen_screen.dart'; // Import DokumenScreen
import '../auth/profile_screen.dart'; // Import ProfileScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets for different tabs
  final List<Widget> _widgetOptions = [
    HomeContent(), // Home content with doctor images
    PasienScreen(),
    DokumenScreen(), // Call DokumenScreen here
    ProfileScreen(), // Call ProfileScreen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: SidebarMenu(
        onFilterByDateRange: (DateTimeRange range) {
          // Add your logic to filter data by date range here
          print("Selected range: ${range.start} - ${range.end}");
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: _widgetOptions[_selectedIndex], // Menampilkan konten utama
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// This is the Home content (doctor images)
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Daftar gambar
  final List<String> _images = [
    'assets/images/hero.jpg', // Path gambar
    'assets/images/klinik.jpg', // Path gambar
    'assets/images/doctor3.png', // Path gambar
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView untuk gambar dokter, berada tepat di bawah AppBar
        Container(
          height: 250, // Atur tinggi gambar
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 330, // Sesuaikan lebar gambar
                      height: 330, // Sesuaikan tinggi gambar
                      child: Image.asset(
                        _images[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16), // Jarak antara gambar dan dots indicator
        // Dots indikator untuk menunjukkan gambar mana yang aktif
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: _currentPage == index ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
        SizedBox(height: 16),
        // Menambahkan teks "Riwayat Pasien"
        Text(
          'Riwayat Pasien',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16), // Jarak sebelum teks "Riwayat Pasien"
        // Menampilkan daftar pasien
        Expanded(
          child: FutureBuilder<List<String>>(
            future: _fetchPatientNames(), // Mengambil nama pasien
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final patientNames = snapshot.data!;
                return ListView.builder(
                  itemCount: patientNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0), // Jarak vertikal
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/pasien.jpg'), // Ganti dengan path foto pasien
                          radius: 25, // Atur radius lingkaran
                        ),
                        title: Text(patientNames[index]),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No patients found.'));
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<String>> _fetchPatientNames() async {
    // Mengambil daftar pasien dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pasienString = prefs.getString('pasienList');
    if (pasienString != null) {
      List<dynamic> pasienList = json.decode(pasienString);
      // Pastikan untuk mengonversi ke List<String>
      return pasienList
          .map<String>((pasien) => pasien['name'].toString())
          .toList();
    }
    return []; // Mengembalikan list kosong jika tidak ada data
  }
}