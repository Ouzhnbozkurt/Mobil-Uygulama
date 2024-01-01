import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/authService.dart';
import 'package:mobil_uygulama/services/productService.dart';
import 'package:mobil_uygulama/services/cartService.dart';
import 'package:mobil_uygulama/urunduzenle.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

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
    setState(() {});
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
                return Card(
                  child: ListTile(
                    title: Text(urunler[index]["ad"] ?? ""),
                    subtitle: Text('Fiyat: ${urunler[index]["fiyat"]} TL'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Admin kontrolü
                        _isAdmin.then((bool isAdmin) {
                          // Yönetici kontrolü
                          if (isAdmin) {
                            // Adminse yapılacak işlemleri buraya ekleyebilirsiniz
                            if (kDebugMode) {
                              print("Admin Butona tıklandı: ${urunler[index]["ad"]}");
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UrunDuzenle(
                                  productId: urunler[index]["id"],
                                  productName: urunler[index]["ad"],
                                  productPrice: urunler[index]["fiyat"],
                                ),
                              ),
                            ).then((_) {
                              // Geri dönüldüğünde verileri güncelle
                              _updateProductList();
                            });
                          } else {
                            // Admin değilse sepete ekle işlemi
                            _cartService.createCart(urun: '${urunler[index]["id"]}'); // Sepete ekle fonksiyonu burada çağrılıyor
                            if (kDebugMode) {
                              print("Kullanıcı Butona tıklandı: ${urunler[index]["ad"]}");
                            }
                          }
                        });
                      },
                      child: FutureBuilder<bool>(
                        future: _isAdmin,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Hata: ${snapshot.error}');
                          } else {
                            bool isAdmin = snapshot.data ?? false;
                            return Text(
                              isAdmin ? 'Düzenle' : 'Sepete Ekle',
                              style: const TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                            );
                          }
                        },
                      ),
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