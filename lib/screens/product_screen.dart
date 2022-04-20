// ignore_for_file: use_key_in_widget_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/consts.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/loguin_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  const ProductScreen(this.product);

  @override
  // ignore: no_logic_in_create_state
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  int activeIndex = 0;
  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secundaryColor,
        title: Text(product.title.toString()),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
            child: CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() => activeIndex = index);
                  },
                  height: 400.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true),
              items: product.images!.map((url) {
                return Builder(builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(url), fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(36))),
                      ));
                });
              }).toList(),
            ),
          ),
          Center(
            child: buildIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title.toString(),
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.5),
                    children: product.sizes!.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: size == s ? primaryColor : Colors.grey,
                                  width: 2.0),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              )),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: TextButton(
                    onPressed: UserModel.of(context).isLoggedIn()
                        ? size != null
                            ? () {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = size;
                                cartProduct.quantity = 1;
                                cartProduct.pid = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;
                                CartModel.of(context).addCartItem(cartProduct);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                              }
                            : () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      const Text("Selecione algum tamanho!"),
                                  backgroundColor: primaryColor,
                                  duration: const Duration(seconds: 2),
                                ));
                              }
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoguinScreen()));
                          },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor)),
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao carrinho"
                          : "Entre para comprar",
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
                const Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description.toString(),
                  style: const TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: product.images!.length,
        effect: ScaleEffect(
            dotWidth: 7.0, dotHeight: 7.0, activeDotColor: primaryColor),
      );
}
