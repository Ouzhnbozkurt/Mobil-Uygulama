import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/authService.dart';
import 'package:mobil_uygulama/services/productService.dart';

class anasayfa extends StatefulWidget {
  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();

  Future<bool> get isAdmin async => await _authService.isAdmin();
  late Future<List<Map<String, dynamic>>> urunlerFuture;

  @override
  void initState() {
    super.initState();
    urunlerFuture = _productService.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: urunlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future henüz tamamlanmamışsa
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Hata durumu
            return Text('Hata: ${snapshot.error}');
          } else {
            // Future başarıyla tamamlandıysa
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
                        isAdmin.then((bool isAdmin) {
                          // Yönetici kontrolü

                          if (isAdmin) {
                            // Adminse yapılacak işlemleri buraya ekleyebilirsiniz
                            print("Admin Butona tıklandı: ${urunler[index]["ad"]}");
                          } else {
                            // Admin değilse sepete ekle işlemi
                            print("Kullanıcı Butona tıklandı: ${urunler[index]["ad"]}");
                          }
                        });
                      },
                      child: FutureBuilder<bool>(
                        future: isAdmin,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Future henüz tamamlanmamışsa
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Hata durumu
                            return Text('Hata: ${snapshot.error}');
                          } else {
                            // Future başarıyla tamamlandıysa
                            bool isAdmin = snapshot.data ?? false;
                            return Text(isAdmin ? 'Düzenle' : 'Sepete Ekle');
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
  runApp(MaterialApp(
    home: anasayfa(),
  ));
}
