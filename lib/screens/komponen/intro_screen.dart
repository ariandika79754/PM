import 'package:flutter/material.dart';
import '../auth/login_register_selection.dart';
import '../../widgets/dot_indicator.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;
  PageController _pageController = PageController();

  List<Widget> introPages = [
    buildPage(
      'assets/images/doctor1.png',
      'Terpadu',
      'Puskesla menyediakan platform terpadu untuk mengelola data pasien anda.',
    ),
    buildPage(
      'assets/images/dokter.png',
      'Digital',
      'Simpan data secara aman dan dapat diakses kapanpun.',
    ),
    buildPage(
      'assets/images/doctor3.png',
      'Andal',
      'Akses puskesla kapanpun dan di manapun tanpa internet.',
    ),
  ];
  static Widget buildPage(String imagePath, String title, String subtitle,
      {double imageHeight = 250}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Elemen berada di tengah
      children: [
        SizedBox(height: 40), // Jarak gambar ke atas
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Image.asset(
            imagePath,
            height: imageHeight, // Tinggi gambar berdasarkan parameter
          ),
        ),
        SizedBox(height: 20), // Jarak proporsional antara gambar dan teks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(height: 10), // Jarak kecil antara judul dan deskripsi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  void nextPage() {
    if (currentIndex < introPages.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterSelection()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: introPages.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return introPages[index];
            },
          ),
          Positioned(
            left: 20,
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                introPages.length,
                (index) => DotIndicator(isActive: index == currentIndex),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              onPressed: nextPage,
              child: Text(
                currentIndex == introPages.length - 1 ? 'Masuk' : 'Lanjutkan',
                style:
                    TextStyle(color: Colors.white), // Tambahkan style di sini
              ),
            ),
          ),
        ],
      ),
    );
  }
}
