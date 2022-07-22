import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/consts.dart';
import 'package:loja_virtual/tiles/product_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  double? _toDouble(dynamic x) {
    return double.tryParse(x.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget _buidBodyBack() =>
        Container(decoration: BoxDecoration(color: secundaryColor));
    return Stack(
      children: [
        _buidBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(title: Text("Novidades")),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data!.docs.map((doc) {
                      return StaggeredTile.count(
                          doc.data()["x"], _toDouble(doc.data()["y"]));
                    }).toList(),
                    children: snapshot.data!.docs.map((doc) {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc.data()["image"],
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}

// class HomeTab extends StatefulWidget {
//   HomeTab({Key? key}) : super(key: key);

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   int activeIndex = 0;
//   List highlights = ['https://images.pexels.com/photos/8095682/pexels-photo-8095682.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
//             child: CarouselSlider(
//               options: CarouselOptions(
//                   onPageChanged: (index, reason) {
//                     setState(() => activeIndex = index);
//                   },
//                   height: 400.0,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 7),
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   enlargeCenterPage: true),
//               items: highlights.map((url) {
//                 return Builder(builder: (BuildContext context) {
//                   return Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(url), fit: BoxFit.cover),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(36))),
//                       ));
//                 });
//               }).toList(),
//             ),
//           ),
//           const Text("Destaques", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance.collection("products").get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           var divideTiles = ListTile.divideTiles(
//                   tiles: snapshot.data!.docs.map((doc) {
//                     return ProductTile(doc);
//                   }).toList(),
//                   color: Colors.grey)
//               .toList();

//           return ListView(
//             children: divideTiles,
//           );
//         }
//       },
//     );,
//             ),
//           )
//         ]
//       )
//     );
//   }
// }