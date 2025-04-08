import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key, this.pageController});

  final PageController? pageController;


  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Flutter's\nClothing",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Olá, ${!model.isLoggedIn() ? "" :model.userData["name"] }",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(!model.isLoggedIn()){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
                                    }else{
                                      model.signOut();
                                    }

                                  },
                                  child: Text(
                                    !model.isLoggedIn() ?
                                    "Entre ou cadastre-se >" : "Sair",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white,),
              DrawerTile(icon: Icons.home, text: 'Início', controller: pageController,page: 0,),
              DrawerTile(icon:  Icons.list, text: 'Produtos', controller: pageController,page:1),
              DrawerTile(icon: Icons.location_on, text: 'Lojas', controller: pageController,page:2),
              DrawerTile(icon: Icons.playlist_add_check, text: 'Meus Pedidos', controller: pageController, page:3),
            ],
          ),

        ],
      ),
    );
  }
}
