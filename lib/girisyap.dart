import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/uyeol.dart';
import 'services/authService.dart';

class girisyap extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create an instance of AuthService
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
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
                        // Call signIn method from AuthService
                        _authService.signIn(
                          context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
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
              onPressed: () {
                _onUyeOlButtonClick(context);
              },
              child: Text('Üye Ol'),
            ),
          ],
        ),
      ),
    );
  }

  void _onUyeOlButtonClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => uyeol()),
    );
    if (kDebugMode) {
      print("Üye ol butonuna tıklandı");
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Builder(
      builder: (context) => girisyap(),
    ),
  ));
}
