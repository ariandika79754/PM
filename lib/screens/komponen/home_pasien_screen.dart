import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layoutpasien/riwayat_kunjungan_screen.dart';
import '../layoutpasien/buat_janji_screen.dart';
import '../layoutpasien/hasil_tes_screen.dart';
import '../layoutpasien/bantuan_screen.dart';
import '../layoutpasien/profile_screen.dart';
import '../auth/login_screen.dart';
import '../alatguladarahpasien/alat_gula_darah_screen.dart'; // Tambahkan ini

class HomePasienScreen extends StatefulWidget {
  @override
  _HomePasienScreenState createState() => _HomePasienScreenState();
}

class _HomePasienScreenState extends State<HomePasienScreen> {
  int _currentIndex = 0;
  String? _userEmail;
  String? _userAvatar;
  final List<String> _imageAssets = [
    'assets/images/hero.jpg',
    'assets/images/klinik.jpg',
    'assets/images/klinik.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('email') ?? 'pasien@example.com'; // Default
      _userAvatar = prefs.getString('avatar') ??
          'assets/images/default_avatar.png'; // Default avatar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Pasien',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
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
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              children: [
                Stack(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text('Pasien'),
                      accountEmail: Text(_userEmail ?? 'pasien@example.com'),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage(
                            _userAvatar ?? 'assets/images/default_avatar.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context); // Untuk menutup drawer
                        },
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.monitor_heart),
                  title: Text('Alat Gula Darah'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AlatGulaDarahScreen(), // Arahkan ke AlatGulaDarahScreen
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text('Keluar'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Selamat datang, Pasien!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 160, // Tetap tinggi gambar
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: _imageAssets.length,
                    pageSnapping: true,
                    controller: PageController(
                        viewportFraction: 1), // Mengatur jarak antar gambar
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0), // Menambahkan padding di sisi
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            _imageAssets[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 130.0, bottom: 20.0), // Atur jarak ke bawah
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _imageAssets.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? Colors.green
                                      : Colors.grey.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(
                    icon: Icons.folder_shared,
                    label: 'Riwayat Kunjungan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiwayatKunjunganScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.assignment_turned_in,
                    label: 'Hasil Tes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HasilTesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.support_agent,
                    label: 'Bantuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BantuanScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
