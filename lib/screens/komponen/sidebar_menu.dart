import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SidebarMenu extends StatelessWidget {
  final Function(DateTimeRange) onFilterByDateRange;

  SidebarMenu({required this.onFilterByDateRange});

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
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Data Pasien',
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
              // Menghitung rentang tanggal minggu ini
              DateTime now = DateTime.now();
              DateTime startOfWeek =
                  now.subtract(Duration(days: now.weekday - 1));
              DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
              Navigator.pop(context); // Menutup drawer
              onFilterByDateRange(
                  DateTimeRange(start: startOfWeek, end: endOfWeek));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month),
            title: Text('Bulan Ini'),
            onTap: () {
              DateTime now = DateTime.now();
              DateTime startOfMonth = DateTime(now.year, now.month, 1);
              DateTime endOfMonth =
                  DateTime(now.year, now.month + 1, 0); // Akhir bulan
              Navigator.pop(context);
              onFilterByDateRange(
                  DateTimeRange(start: startOfMonth, end: endOfMonth));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Tahun Ini'),
            onTap: () {
              DateTime now = DateTime.now();
              DateTime startOfYear = DateTime(now.year, 1, 1);
              DateTime endOfYear = DateTime(now.year + 1, 1, 0); // Akhir tahun
              Navigator.pop(context);
              onFilterByDateRange(
                  DateTimeRange(start: startOfYear, end: endOfYear));
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
    );
  }
}
