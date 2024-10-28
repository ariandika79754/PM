import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For converting test results to JSON
import 'detail_pasien_screen.dart'; // Import your DetailPasienScreen here

class HasilTesScreen extends StatefulWidget {
  @override
  _HasilTesScreenState createState() => _HasilTesScreenState();
}

class _HasilTesScreenState extends State<HasilTesScreen> {
  String? loggedInUsername; // Variable to store logged-in username
  List<Map<String, dynamic>> pasienGulaDarahList =
      []; // List to store patient results

  @override
  void initState() {
    super.initState();
    _loadLoggedInUsername(); // Load username on initialization
  }

  // Load the logged-in username from SharedPreferences
  Future<void> _loadLoggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUsername =
          prefs.getString('username'); // Get username from SharedPreferences
    });
    _loadPasienGulaDarahList(); // Load patient results after getting username
  }

  // Load patient results from SharedPreferences
  Future<void> _loadPasienGulaDarahList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pasienGulaDarahString = prefs.getString('pasienGulaDarahList');
    if (pasienGulaDarahString != null) {
      List<Map<String, dynamic>> allPasienGulaDarah =
          List<Map<String, dynamic>>.from(json.decode(pasienGulaDarahString));
      setState(() {
        // Filter patient results based on the logged-in username
        pasienGulaDarahList = allPasienGulaDarah
            .where((hasil) => hasil['username'] == loggedInUsername)
            .toList();
      });
    }
  }

  // Navigate to DetailPasienScreen when an item is clicked
  void _navigateToDetail(Map<String, dynamic> pasienData) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailPasienScreen(pasienData: pasienData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Tes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: pasienGulaDarahList.isNotEmpty
          ? ListView.builder(
              itemCount: pasienGulaDarahList.length,
              itemBuilder: (context, index) {
                final hasil = pasienGulaDarahList[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(
                      hasil), // Handle click to navigate to detail screen
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              hasil['nama']
                                  [0], // Display first letter of name as avatar
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              hasil['nama'], // Display patient's name
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('Tidak ada hasil tes.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            ),
    );
  }
}
