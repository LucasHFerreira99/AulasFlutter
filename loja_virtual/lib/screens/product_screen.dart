import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

import '../datas/product_data.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.product});

  final ProductData product;

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: Text(product.title!), centerTitle: true),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: AnotherCarousel(
              images:
                  product.images!.map((url) {
                    return NetworkImage(url);
                  }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title!,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children:
                        product.sizes!.map((s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                border: Border.all(
                                  color: s == size ? primaryColor : Colors.grey,
                                  width: 3,
                                ),
                              ),
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(s),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, ),
                        onPressed: size != null ? (){
                          if(UserModel.of(context).isLoggedIn()){
                            CartProduct cartProduct = new CartProduct();
                            cartProduct.size = size!;
                            cartProduct.quantity = 1;
                            cartProduct.pid = product.id!;
                            cartProduct.category = product.category!;

                            CartModel.of(context).addCartItem(cartProduct);

                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => CartScreen())
                            );
                          }else{
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => LoginScreen())
                              );
                          }
                        } : null,
                        child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho" : "Entre para comprar", style: TextStyle(fontSize: 18, color: Colors.white),)
                    ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(product.description!, style: TextStyle(fontSize: 16),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
