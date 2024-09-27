import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            // Menambahkan simbol X di pojok kanan atas
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Menutup drawer saat X ditekan
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Padding untuk kebawah sedikit
                    child: Text(
                      'Riwayat Terakhir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Minggu Ini'),
            onTap: () {
              // Aksi saat "Minggu Ini" diklik
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month),
            title: Text('Bulan Ini'),
            onTap: () {
              // Aksi saat "Bulan Ini" diklik
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Tahun Ini'),
            onTap: () {
              // Aksi saat "Tahun Ini" diklik
            },
          ),
        ],
      ),
    );
  }
}
