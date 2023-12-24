import 'package:flutter/material.dart';

class uyeol extends StatefulWidget {
  @override
  _uyeolState createState() => _uyeolState();
}

class _uyeolState extends State<uyeol> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Üye Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ad Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı ve soyadınızı girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir e-mail girin';
                  }
                  // E-mail format kontrolü ekleyebilirsiniz.
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
                    // Üye olma işlemleri burada gerçekleştirilebilir
                    print('Ad Soyad: ${_nameController.text}');
                    print('E-mail: ${_emailController.text}');
                    print('Şifre: ${_passwordController.text}');
                  }
                },
                child: Text('Üye Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: uyeol(),
  ));
}