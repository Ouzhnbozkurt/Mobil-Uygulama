import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartService {
  final cartCollection = FirebaseFirestore.instance.collection("carts");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> createCart({required String urun}) async {
    try {
      // Kontrol et: Eğer aynı ürün zaten sepetinizde varsa eklemeyi yapma
      bool isAlreadyInCart = await isProductInCart(urun);

      if (!isAlreadyInCart) {
        await cartCollection.add({
          "urun": FirebaseFirestore.instance.doc('products/$urun'),
          "user": FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'),
        });
        Fluttertoast.showToast(
          msg: "Ürün Sepete Eklendi",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Bu ürün zaten sepetinizde",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Sepete Eklenirken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Yeni eklenen fonksiyon: Belirli bir ürünün sepete eklenip eklenmediğini kontrol eder
  Future<bool> isProductInCart(String productId) async {
    try {
      QuerySnapshot querySnapshot = await cartCollection
          .where("user",
          isEqualTo: FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'))
          .where("urun",
          isEqualTo: FirebaseFirestore.instance.doc('products/$productId'))
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      return false;
    }
  }

  Future<void> removeCartItem(String productId) async {
    try {
      await cartCollection
          .where("user",
              isEqualTo: FirebaseFirestore.instance
                  .doc('users/${firebaseAuth.currentUser!.uid}'))
          .where("urun",
              isEqualTo: FirebaseFirestore.instance.doc('products/$productId'))
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      Fluttertoast.showToast(
          msg: "Sepetteki Ürün Kaldırıldı.", toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Sepetten Kaldırılırken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<List<DocumentSnapshot>> getCartItems() async {
    try {
      QuerySnapshot querySnapshot = await cartCollection
          .where("user",
              isEqualTo: FirebaseFirestore.instance
                  .doc('users/${firebaseAuth.currentUser!.uid}'))
          .get();
      return querySnapshot.docs;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      return [];
    }
  }
}
