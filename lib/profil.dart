import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_uygulama/girisyap.dart';
import 'package:mobil_uygulama/main.dart';

class profil extends StatefulWidget {
  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          User? user = _auth.currentUser;
          if (user != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'E-mail: ${user.email ?? "Belirtilmemiş"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GirisKontrol()),
                      );
                    },
                    child: Text('Çıkış Yap'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'Kullanıcı bulunamadı',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}

class Girisyap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Giriş Yap Sayfası',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: profil(),
  ));
}
