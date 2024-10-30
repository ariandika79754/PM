import 'package:flutter/material.dart';

class JadwalKlinikScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Klinik',
          style: TextStyle(
            fontSize: 20, // Ukuran font
            fontFamily: 'Times New Roman', // Font Latin
            color: Colors.white, // Warna putih
          ),
        ),
        backgroundColor: Colors.green, // Warna latar AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            SizedBox(height: 20),
            _buildDaySchedule(
              day: 'Senin - Kamis',
              time: '08:00 - 16:00',
              breakTime: '11:40 - 13:00',
            ),
            SizedBox(height: 16),
            _buildDaySchedule(
              day: 'Jumat',
              time: '08:00 - 16:00',
              breakTime: 'Istirahat: 11:40 - 13:30',
            ),
            SizedBox(height: 30),
            Center(
              child: Icon(
                Icons.access_time,
                size: 80,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Pastikan untuk datang sesuai jam operasional.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule({
    required String day,
    required String time,
    required String breakTime,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Jam Buka: $time',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 4),
          Text(
            breakTime,
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
