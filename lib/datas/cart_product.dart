import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  String? cid;
  String? category;
  String? pid;
  int? quantity;
  String? size;
  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = (document.data() as Map)["category"];
    pid = (document.data() as Map)["pid"];
    quantity = (document.data() as Map)["quantity"];
    size = (document.data() as Map)["size"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData!.toResumedMap()
    };
  }
}
