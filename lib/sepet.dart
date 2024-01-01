import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Sepet extends StatefulWidget {
  const Sepet({super.key});

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  // Örnek ürün verileri
  List<Map<String, dynamic>> urunler = [
    {"ad": "Ürün 1", "fiyat": 20.0},
    {"ad": "Ürün 2", "fiyat": 30.0},
    {"ad": "Ürün 3", "fiyat": 25.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: urunler.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(urunler[index]["ad"]),
              subtitle: Text('Fiyat: ${urunler[index]["fiyat"]} TL'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Butona tıklandığında yapılacak işlemleri buraya ekleyebilirsiniz
                  if (kDebugMode) {
                    print("Butona tıklandı: ${urunler[index]["ad"]}");
                  }
                },
                child: const Text(
                  'Kaldır',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Sepet(),
  ));
}