import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/authService.dart';
import 'package:mobil_uygulama/services/productService.dart';
import 'package:mobil_uygulama/services/cartService.dart';
import 'package:mobil_uygulama/services/wishlistService.dart';
import 'package:mobil_uygulama/urunduzenle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();
  final firebaseAuth = FirebaseAuth.instance;

  Future<bool> _isAdmin = Future<bool>.value(false);
  late Future<List<Map<String, dynamic>>> urunlerFuture;

  @override
  void initState() {
    super.initState();
    _updateAdminStatus();
    urunlerFuture = _productService.getAllProducts();
  }

  Future<void> _updateAdminStatus() async {
    _isAdmin = _authService.isAdmin();
  }

  Future<void> _updateProductList() async {
    setState(() {
      urunlerFuture = _productService.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: urunlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> urunler = snapshot.data ?? [];
            return ListView.builder(
              itemCount: urunler.length,
              itemBuilder: (context, index) {
                List<Widget> buttons = [];

                final isAdmin = firebaseAuth.currentUser?.email;
                if (isAdmin != "admin@admin.com") {
                  buttons.add(
                    ElevatedButton(
                      onPressed: () {
                        _wishlistService.createWish(
                            urun: '${urunler[index]["id"]}');
                        if (kDebugMode) {
                          print(
                              "İstek Listesi Butona tıklandı: ${urunler[index]["ad"]}");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        textStyle: const TextStyle(fontSize: 12.0),
                      ),
                      child: const Text(
                        'İstek Listesi',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  );
                }
                buttons.add(
                  ElevatedButton(
                    onPressed: () {
                      _isAdmin.then((bool isAdmin) {
                        if (isAdmin) {
                          if (kDebugMode) {
                            print(
                                "Admin Butona tıklandı: ${urunler[index]["ad"]}");
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UrunDuzenle(
                                    productId: urunler[index]["id"],
                                    productName: urunler[index]["ad"],
                                    productPrice: urunler[index]["fiyat"],
                                  ),
                            ),
                          ).then((_) {
                            _updateProductList();
                          });
                        } else {
                          _cartService.createCart(
                              urun: '${urunler[index]["id"]}');
                          if (kDebugMode) {
                            print(
                                "Kullanıcı Butona tıklandı: ${urunler[index]["ad"]}");
                          }
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      textStyle: const TextStyle(fontSize: 12.0),
                    ),
                    child: FutureBuilder<bool>(
                      future: _isAdmin,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else {
                          bool isAdmin = snapshot.data ?? false;
                          return Text(
                            isAdmin ? 'Düzenle' : 'Sepete Ekle',
                            style: const TextStyle(
                              color: Colors.purple,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );

                return Card(
                  child: ListTile(
                    title: Text(urunler[index]["ad"] ?? ""),
                    subtitle: Text('Fiyat: ${urunler[index]["fiyat"]} TL'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: buttons,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Anasayfa(),
  ));
}
