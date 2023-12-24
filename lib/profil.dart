import 'package:mobil_uygulama/uyeol.dart';
import 'package:flutter/material.dart';

class profil extends StatefulWidget {
  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir e-mail girin';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Şifre'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir şifre girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Giriş butonuna tıklandığında yapılacak işlemleri buraya ekleyebilirsiniz
                        print('E-mail: ${_emailController.text}');
                        print('Şifre: ${_passwordController.text}');
                      }
                    },
                    child: Text('Giriş'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text("Hesabınız yok mu? Üye olun."),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: _onUyeOlButtonClick,
              child: Text('Üye Ol'),
            ),
          ],
        ),
      ),
    );
  }

  void _onUyeOlButtonClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => uyeol()),
    );
    print("Üye ol butonuna tıklandı");
  }
}

void main() {
  runApp(MaterialApp(
    home: profil(),
  ));
}