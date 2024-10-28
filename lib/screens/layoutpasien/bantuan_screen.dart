import 'package:flutter/material.dart';

class BantuanScreen extends StatefulWidget {
  @override
  _BantuanScreenState createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  // Menyimpan daftar pesan
  List<String> messages = [
    'Selamat datang di layanan bantuan klinik! Bagaimana kami bisa membantu Anda?'
  ];
  TextEditingController _controller = TextEditingController();

  // Fungsi untuk mengirim pesan
  void sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add('Anda: $message');
        // Tambahkan respons staff berdasarkan pesan pengguna
        String response = getResponse(message);
        messages.add('Staff: $response');
      });
      _controller.clear();
    }
  }

  // Fungsi untuk menentukan respons berdasarkan input pengguna
  String getResponse(String message) {
    message =
        message.toLowerCase(); // Ubah ke huruf kecil agar case-insensitive

    // Kategori: Kesehatan
    if (message.contains('demam')) {
      return 'Jika Anda mengalami demam, kami sarankan untuk banyak minum air dan mengistirahatkan tubuh Anda. Jika demam tidak kunjung reda, silakan datang ke klinik.';
    } else if (message.contains('batuk')) {
      return 'Untuk batuk, Anda bisa mencoba obat batuk dijual bebas yang sesuai dengan resep dokter. Namun, jika batuk berlanjut, sebaiknya konsultasikan kepada dokter.';
    } else if (message.contains('sakit kepala')) {
      return 'Sakit kepala dapat diatasi dengan istirahat yang cukup dan konsumsi obat pereda nyeri. Jika sakit kepala berlanjut, mohon datang untuk pemeriksaan lebih lanjut.';
    } else if (message.contains('flu')) {
      return 'Gejala flu biasanya meliputi demam, batuk, dan pilek. Jika Anda mengalami gejala ini, kami sarankan untuk beristirahat dan banyak minum cairan.';
    } else if (message.contains('kolesterol tinggi')) {
      return 'Untuk kolesterol tinggi, sebaiknya perhatikan pola makan Anda dan lakukan pemeriksaan rutin di klinik kami. Kami juga dapat memberikan konsultasi diet.';

      // Kategori: Jadwal dan Lokasi
    } else if (message.contains('jam operasional')) {
      return 'Klinik kami buka setiap hari dari jam 8 pagi hingga 6 sore.';
    } else if (message.contains('lokasi')) {
      return 'Kami berlokasi di Jalan Sehat No. 45, dekat dengan pusat perbelanjaan.';
    } else if (message.contains('hubungi')) {
      return 'Anda dapat menghubungi kami di nomor 081234567890 untuk informasi lebih lanjut atau untuk membuat janji temu.';

      // Kategori: Layanan
    } else if (message.contains('vaksinasi')) {
      return 'Kami menyediakan layanan vaksinasi untuk berbagai jenis vaksin. Silakan datang untuk informasi lebih lanjut.';
    } else if (message.contains('konsultasi')) {
      return 'Anda dapat melakukan konsultasi dengan dokter kami. Silakan buat janji temu melalui nomor yang kami sediakan.';

      // Respons default
    } else {
      return 'Terima kasih atas pertanyaannya! Kami sedang memproses. Jika ada pertanyaan lain, silakan ajukan.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bantuan - Chat Bot Klinik',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Align(
                    alignment: messages[index].startsWith('Anda:')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: messages[index].startsWith('Anda:')
                            ? Colors.blue[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(messages[index]),
                    ),
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
                      hintText: 'Ketik pesan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
