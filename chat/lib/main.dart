import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

  FirebaseFirestore.instance.collection("mensagens").doc().set({
    'texto': 'Truta',
    'from': 'Daniekl',
    'read': false
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Testando a conexão com o Firebase após a inicialização
    FirebaseFirestore.instance
        .collection('col')
        .doc("doc")
        .set({"texto": "Lucas"});

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Container(
        color: Colors.blue,
      ),
    );
  }
}
