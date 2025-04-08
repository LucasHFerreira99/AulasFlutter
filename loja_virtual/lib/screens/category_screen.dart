import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(data?["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.grid_on, color: Colors.white)),
              Tab(icon: Icon(Icons.list, color: Colors.white)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('products')
                  .doc(snapshot.id)
                  .collection("itens")
                  .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ProductData data = ProductData.fromDocument(
                        snapshot.data!.docs[index],
                      );
                      data.category = this.snapshot.id;
                      return ProductTile(type: "grid", product: data);
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ProductData data = ProductData.fromDocument(
                        snapshot.data!.docs[index],
                      );
                      data.category = this.snapshot.id;
                      return ProductTile(type: "list", product: data);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
