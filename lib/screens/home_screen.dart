import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/custom_bottom_nav.dart';
import 'sidebar_menu.dart';
import 'pasien_screen.dart'; // Import PasienScreen
import 'dokumen_screen.dart'; // Import DokumenScreen
import 'profile_screen.dart'; // Import ProfileScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets to call based on the index
  final List<Widget> _widgetOptions = [
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    PasienScreen(),
    DokumenScreen(), // Call the DokumenScreen here
    ProfileScreen(), // Panggil ProfileScreen di sini
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
                // Buka Drawer menggunakan context yang benar
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: SidebarMenu(), // Panggil SidebarMenu di sini
      body: Center(
        // Display widget based on the current index
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
