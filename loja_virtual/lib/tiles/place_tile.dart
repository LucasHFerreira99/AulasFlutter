import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceTile extends StatelessWidget {
  PlaceTile({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(data["image"], fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  data["address"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: TextButton(
                  onPressed: () {
                    launchUrlString("https://www.google.com/maps/search/?api=1&query=${data["lat"]},${data["long"]}");
                  },
                  child: Text(
                    "Ver no mapa",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: TextButton(
                  onPressed: () {
                    launchUrlString("tel:${data["phone"]}");
                  },
                  child: Text("Ligar", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
