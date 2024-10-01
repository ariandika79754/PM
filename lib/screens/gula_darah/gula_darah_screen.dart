import 'package:flutter/material.dart';
import 'add_pasien_screen.dart';
import 'detail_pasien_screen.dart';

class GulaDarahScreen extends StatefulWidget {
  @override
  _GulaDarahScreenState createState() => _GulaDarahScreenState();
}

class _GulaDarahScreenState extends State<GulaDarahScreen> {
  List<Map<String, dynamic>> pasienList = []; // List to hold all patient data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Cek Laborat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
              
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search Pasien',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: pasienList.isEmpty
                  ? Center(child: Text("Belum Ada Data Pasien"))
                  : ListView.builder(
                      itemCount: pasienList.length,
                      itemBuilder: (context, index) {
                        var pasien = pasienList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/gula_darah.png'),
                          ),
                          title: Text(pasien['nama']),
                          subtitle: Text(pasien['tanggal']),
                          onTap: () {
                            // Navigate to DetailPasienScreen when clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPasienScreen(
                                  pasienData: pasien,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPasienScreen(),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              pasienList.add(result); // Add new patient to the list
            });
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
