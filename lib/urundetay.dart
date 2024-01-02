import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/cartService.dart';
import 'package:mobil_uygulama/services/wishlistService.dart';
import 'package:mobil_uygulama/services/favoriteProductService.dart';

class UrunDetay extends StatelessWidget {
  final Map<String, dynamic> product;

  UrunDetay({Key? key, required this.product}) : super(key: key);

  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["ad"] ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Açıklama: ${product["aciklama"] ?? ""}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Fiyat: ${product["fiyat"]} TL',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Diğer ürün detayları
            const SizedBox(height: 16.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                // Favori listesine ekleme işlemleri buraya gelecek
                _favoriteService.createFavorite(
                  urun: '${product["id"]}',
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text(
                'Favori Listesi',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                // İstek listesine ekleme işlemleri buraya gelecek
                _wishlistService.createWish(
                  urun: '${product["id"]}',
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text(
                'İstek Listesi',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                // Sepete ekleme işlemleri buraya gelecek
                _cartService.createCart(
                  urun: '${product["id"]}',
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text(
                'Sepet',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
