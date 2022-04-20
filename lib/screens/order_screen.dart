import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;

  OrderScreen(String this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Pedido realizado"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 80.0,
                ),
                const Text(
                  "Pedido realizado com sucesso!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Text(
                  "Código do pedido: $orderId",
                  style: const TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ));
  }
}
