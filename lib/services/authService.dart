import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context,
      {required String name,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await _registerUser(name: name, email: email, password: password);
        Fluttertoast.showToast(
            msg: "Üyelik Oluşturuldu.", toastLength: Toast.LENGTH_LONG);
        _navigateToHomePage(context);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "Giriş Başarılı.", toastLength: Toast.LENGTH_LONG);
        _navigateToHomePage(context);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String email,
      required String password}) async {
    await userCollection
        .doc()
        .set({"name": name, "email": email, "password": password});
  }

  Future<bool> isAdmin() async {
    final user = firebaseAuth.currentUser;
    // Kullanıcı mevcut ve e-posta admin@admin.com ise yönetici olarak kabul edelim
    return user != null && user.email == "admin@admin.com";
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Urunler()),
    );
  }
}
