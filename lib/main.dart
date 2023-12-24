import 'package:mobil_uygulama/profil.dart';
import 'package:mobil_uygulama/anasayfa.dart';
import 'package:mobil_uygulama/sepet.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Urunler(),
    );
  }
}

class Urunler extends StatefulWidget {
  const Urunler({Key? key});

  @override
  State<Urunler> createState() => _UrunlerState();
}

class _UrunlerState extends State<Urunler> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş Uygulaması'),
      ),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return anasayfa();
      case 1:
        return sepet();
      case 2:
        return profil();
      default:
        return Container(); // Fallback, boş bir container veya hata sayfası eklenebilir.
    }
  }
}