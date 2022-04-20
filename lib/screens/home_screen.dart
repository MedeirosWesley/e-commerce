import 'package:flutter/material.dart';
import 'package:loja_virtual/consts.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _pageControler = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageControler,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(_pageControler),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: secundaryColor,
          ),
          drawer: CustomDrawer(_pageControler),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: secundaryColor,
            title: const Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageControler),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: secundaryColor,
            centerTitle: true,
            title: const Text("Meus pedidos"),
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageControler),
        ),
      ],
    );
  }
}
