import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/cart_model.dart';

class CartPrice extends StatelessWidget {
  CartPrice({super.key, required this.buy});

  VoidCallback buy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
            builder: (context, child, model){

              double price = model.getProductsPrice();
              double discount = model.getDiscount();
              double shipPrice = model.getShipPrice();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Resumo do pedido",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text("R\$ ${price.toStringAsFixed(2)}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Desconto"),
                      Text("R\$ ${discount.toStringAsFixed(2)} "),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Entrega"),
                      Text("R\$ ${shipPrice.toStringAsFixed(2)}"),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                      Text("R\$ ${(price-discount+shipPrice).toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: buy,
                      child: Text("Finalizar Pedido", style: TextStyle(color: Colors.white),),
                     style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,)
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
