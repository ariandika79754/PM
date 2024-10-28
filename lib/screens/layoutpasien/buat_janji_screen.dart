import 'package:flutter/material.dart';

class BuatJanjiScreen extends StatefulWidget {
  @override
  _BuatJanjiScreenState createState() => _BuatJanjiScreenState();
}

class _BuatJanjiScreenState extends State<BuatJanjiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "Pasien", "message": _controller.text});
        _messages.add({
          "sender": "Staff",
          "message": _getBotResponse(),
        });
        _controller.clear();
      });
    }
  }

  String _getBotResponse() {
    final responses = [
      "Terima kasih! Janji telah diterima.",
      "Silakan tunggu, kami akan menghubungi Anda segera.",
      "Apa ada yang bisa kami bantu lebih lanjut?",
    ];
    return responses[(DateTime.now().millisecondsSinceEpoch ~/ 1000) % responses.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Janji'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['sender'] == "Pasien" ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg['sender'] == "Pasien" ? Colors.green[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['message']!, style: TextStyle(color: Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
