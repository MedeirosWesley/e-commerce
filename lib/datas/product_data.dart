import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  List? images;
  List? sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = (snapshot.data() as Map)['title'];
    description = (snapshot.data() as Map)['description'];
    price = (snapshot.data() as Map)['price'];
    images = (snapshot.data() as Map)['images'];
    sizes = (snapshot.data() as Map)['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
