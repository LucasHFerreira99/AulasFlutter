import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapPage(),
    );
  }
}

class MapPage extends StatelessWidget {
  final List<LatLng> polygonPoints = [
    LatLng(-23.5505, -46.6333),
    LatLng(-23.5450, -46.6400),
    LatLng(-23.5600, -46.6450),
    LatLng(-23.5650, -46.6300),
  ];

  // Calcula o centro do polígono para exibir o nome nele
  LatLng getPolygonCenter(List<LatLng> points) {
    double latSum = 0;
    double lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa com Polígono")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-23.5505, -46.6333),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: polygonPoints,
                color: Colors.green.withOpacity(0.5), // Preenchimento colorido
                borderColor: Colors.green,
                borderStrokeWidth: 3,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: getPolygonCenter(polygonPoints),
                width: 100,
                height: 50,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Área 1", // Nome do polígono
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
