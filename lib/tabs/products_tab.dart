import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var divideTiles = ListTile.divideTiles(
                  tiles: snapshot.data!.docs.map((doc) {
                    return CategoryTile(doc);
                  }).toList(),
                  color: Colors.grey)
              .toList();

          return ListView(
            children: divideTiles,
          );
        }
      },
    );
  }
}
