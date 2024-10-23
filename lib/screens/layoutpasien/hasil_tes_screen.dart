import 'package:flutter/material.dart';

class HasilTesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Tes'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text('Halaman Hasil Tes'),
      ),
    );
  }
}
