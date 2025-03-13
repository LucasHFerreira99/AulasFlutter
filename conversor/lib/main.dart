import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=7c7968e6";

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
      home: Home(),
    ),
  );
}

Future<Map> getData() async {
  final response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0;
  double euro = 0;

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar Dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                final data = snapshot.data as Map<String, dynamic>;
                final currencies =
                    data["results"]["currencies"] as Map<String, dynamic>;

                dolar = currencies["USD"]["buy"];
                euro = currencies["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      BuildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      BuildTextField("Doláres", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      BuildTextField("Euros", "€", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

BuildTextField(String label, String prefix, TextEditingController c, ValueChanged<String>  f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25),
      filled: true,
      // Para garantir que o preenchimento seja ativado
      fillColor: Colors.black,
      // Cor de fundo do TextField
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // Borda arredondada
        borderSide: BorderSide(color: Colors.amber, width: 2), // Borda colorida
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // Borda arredondada
        borderSide: BorderSide(
          color: Colors.amber,
          width: 2,
        ), // Borda colorida ao focar
      ),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
