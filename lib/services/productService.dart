import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductService {
  final productCollection = FirebaseFirestore.instance.collection("products");

  Future<void> productCreate({required String ad, required int fiyat}) async {
    try {
      await productCollection.add({
        "ad": ad,
        "fiyat": fiyat,
      });
      Fluttertoast.showToast(
          msg: "Ürün Eklendi",
          toastLength: Toast.LENGTH_SHORT
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Ürün Eklenirken Hata Oluştu",
          toastLength: Toast.LENGTH_SHORT
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await productCollection.get();

      List<Map<String, dynamic>> products = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          "id": doc.id,
          "ad": doc["ad"],
          "fiyat": doc["fiyat"],
        };
      }).toList();

      return products;
    } catch (e) {
      print("Ürünler getirilirken hata oluştu: $e");
      return [];
    }
  }
}