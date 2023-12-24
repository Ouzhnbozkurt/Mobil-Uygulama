import 'package:flutter/material.dart';

class sepet extends StatefulWidget {
  @override
  State<sepet> createState() => _sepetState();
}

class _sepetState extends State<sepet> {
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
                  print("Butona tıklandı: ${urunler[index]["ad"]}");
                },
                child: Text('Kaldır'),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: sepet(),
  ));
}