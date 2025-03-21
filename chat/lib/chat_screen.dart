import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(
          credential,
        );
        return authResult.user;
      }
    } catch (error) {
      print('Erro durante o login: $error');
    }
    return null;
  }

  void _sendMessage({String? text, File? imgFile}) async {
    final User? user = await _getUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível fazer login. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'timestamp': Timestamp.now(),
    };

    if (text != null) data['text'] = text;

    if (imgFile != null) {
      Uint8List uint8list = await imgFile.readAsBytes();
      String base64img = base64Encode(uint8list);
      data['base64img'] = base64img;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  Image _showFile(String base64) {
    return Image.memory(base64Decode(base64));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());

                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data!.docs.reversed.toList();

                    return ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data = documents[index].data() as Map<String, dynamic>;
                        return ChatMessage(data: documents[index].data() as Map<String, dynamic>?, mine: true);
                      },
                    );
                }
              },
            ),
          ),
          TextComposer(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}
