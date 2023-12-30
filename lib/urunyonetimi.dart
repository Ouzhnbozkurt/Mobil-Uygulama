import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final productCollection = FirebaseFirestore.instance.collection("products");

  Future<void> productCreate({required String ad, required int fiyat}) async {
    await productCollection.doc().set({
      "ad": ad,
      "fiyat": fiyat,
    });
  }
}

class urunyonetimi extends StatefulWidget {
  const urunyonetimi({Key? key}) : super(key: key);

  @override
  _urunyonetimiState createState() => _urunyonetimiState();
}

class _urunyonetimiState extends State<urunyonetimi> {
  final TextEditingController _urunAdiController = TextEditingController();
  final TextEditingController _urunFiyatiController = TextEditingController();
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urunAdiController,
              decoration: InputDecoration(labelText: 'Ürün Adı'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _urunFiyatiController,
              decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createProduct();
              },
              child: Text('Ürünü Oluştur'),
            ),
          ],
        ),
      ),
    );
  }

  void _createProduct() {
    final String urunAdi = _urunAdiController.text.trim();
    final int urunFiyati = int.tryParse(_urunFiyatiController.text.trim()) ?? 0;

    if (urunAdi.isNotEmpty && urunFiyati > 0) {
      _productService.productCreate(ad: urunAdi, fiyat: urunFiyati);
      // Ürün oluşturulduktan sonra input alanlarını temizle
      _urunAdiController.clear();
      _urunFiyatiController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen geçerli bir ürün adı ve fiyatı girin.'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: urunyonetimi(),
  ));
}
