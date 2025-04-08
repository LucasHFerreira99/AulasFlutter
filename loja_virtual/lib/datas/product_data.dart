import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{

  String? category;
  String? id;

  String? title;
  String? description;

  double? price;

  List? images;
  List? sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    id = snapshot.id;
    title = data?["title"];
    description = data?["description"];
    price = data?["price"] + 0.0;
    images = data?["images"];
    sizes = data?["sizes"];
  }

  Map<String, dynamic> toResumedMap(){
    return{
      "title": title,
      "price": price
    };
  }

}