import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_uygulama/isteklistesi.dart';
import 'package:mobil_uygulama/main.dart';
import 'package:mobil_uygulama/services/authService.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _isAdmin = Future<bool>.value(false);

  @override
  void initState() {
    super.initState();
    _updateAdminStatus();
  }

  Future<void> _updateAdminStatus() async {
    _isAdmin = AuthService().isAdmin();
    setState(() {});
  }

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
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<bool>(
                    future: _isAdmin,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        bool isAdmin = snapshot.data ?? false;
                        if (!isAdmin) {
                          return ElevatedButton(
                            onPressed: () {
                              // İstek listesi sayfasına geçiş yap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IstekListesi(),
                                ),
                              );
                            },
                            child: const Text(
                              'İstek Listesi',
                              style: TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Empty SizedBox if admin
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GirisKontrol()),
                      );
                    },
                    child: const Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
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

void main() {
  runApp(const MaterialApp(
    home: Profil(),
  ));
}
