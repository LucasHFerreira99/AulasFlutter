import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../screens/login_screen.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){
      String uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("users").doc(uid).collection("orders").get(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return ListView(
                children: snapshot.data!.docs.map((doc) => OrderTile(orderId: doc.id)).toList().reversed.toList(),
              );
            }
          }
      );

    }else{
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_list, size: 80, color: Theme
                .of(context)
                .primaryColor,),
            SizedBox(height: 16,),
            Text("Faça o login para acompanhar seus pedidos!",
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
    }
  }
}
