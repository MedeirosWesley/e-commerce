import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCart extends StatelessWidget {
  const DiscountCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de desconto",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.shade700),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupom"),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("coupons")
                    .doc(text.toUpperCase())
                    .get()
                    .then((docSnap) {
                  if (docSnap.data() != null) {
                    CartModel.of(context).setCoupon(
                        text.toUpperCase(), (docSnap.data() as Map)["percent"]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Desconto de ${(docSnap.data() as Map)["percent"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: const Duration(seconds: 2),
                    ));
                  } else {
                    CartModel.of(context).setCoupon(null, 0);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Cupom não existente!"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
