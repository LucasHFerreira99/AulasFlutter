import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/cart_tile.dart';
import '../widgets/ship_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Meu Carrinho"),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  int p = model.products.length;
                  return Text(
                    "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
                },
              ),
            ),
          ]
      ),
      body: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            if (model.isLoading && UserModel.of(context).isLoggedIn()) {
              return Center(
                  child: CircularProgressIndicator()
              );
            } else if (!UserModel.of(context).isLoggedIn()) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart, size: 80, color: Theme
                        .of(context)
                        .primaryColor,),
                    SizedBox(height: 16,),
                    Text("Faça o login para adicionar produtos!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen())
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme
                            .of(context)
                            .primaryColor),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(5),
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              );
            }else if(model.products.length == 0){
              return Center(
                child: Text("Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              );
            }else{
              return ListView(
                children: [
                  Column(
                    children: model.products.map(
                        (product){
                          return CartTile(cartProduct: product,);
                        }
                    ).toList(),
                  ),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(buy: () async{
                    String? orderId = await model.finishOrder();
                    if(orderId != null){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OrderScreen(orderId: orderId)));
                    }
                  })
                ],
              );
            }

          }
      ),
    );
  }
}
