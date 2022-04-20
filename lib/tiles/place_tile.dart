import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  const PlaceTile(QueryDocumentSnapshot<Object?> this.snapshot, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.data() as Map;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.0,
            child: Image.network(
              snapshotData["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshotData["title"],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(snapshotData["adress"], textAlign: TextAlign.start),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor)),
                    onPressed: () {
                      launch(
                          "https://www.google.com/maps/search/?api=1&query=${snapshotData["lat"]},${snapshotData["long"]}");
                    },
                    child: const Text(
                      "Ver no Mapa",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor)),
                    onPressed: () {
                      launch("tel:${snapshotData["phone"]}");
                    },
                    child: const Text(
                      "Ligar",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
