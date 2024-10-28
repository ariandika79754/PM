import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_alat_gula_darah_screen.dart';

class AlatGulaDarahScreen extends StatefulWidget {
  @override
  _AlatGulaDarahScreenState createState() => _AlatGulaDarahScreenState();
}

class _AlatGulaDarahScreenState extends State<AlatGulaDarahScreen> {
  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> filteredList = []; // List for filtered results
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAlatList();
  }

  Future<void> _loadAlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? alatString = prefs.getString('alatList');
    if (alatString != null) {
      List<dynamic> alatJson = json.decode(alatString);
      alatList =
          alatJson.map((alat) => Map<String, dynamic>.from(alat)).toList();
      filteredList = alatList; // Initialize filtered list
      setState(() {});
    }
  }

  void _searchAlat(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all items
      setState(() {
        filteredList = alatList;
      });
    } else {
      // Filter the alatList based on the search query
      setState(() {
        filteredList = alatList.where((alat) {
          return alat['name'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alat Gula Darah'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _searchAlat,
              decoration: InputDecoration(
                labelText: 'Cari Alat Gula Darah',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length, // Use filtered list
                itemBuilder: (context, index) {
                  final alat = filteredList[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(alat['name']),
                      subtitle: Text('Stok: ${alat['stok']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailAlatGulaDarahScreen(
                              alatGulaDarah: alat, // Pass the selected alat
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
