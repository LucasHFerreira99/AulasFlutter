import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, this.data, required this.mine});

  final Map<String, dynamic>? data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    // Verifica se 'data' ou 'senderPhotoUrl' são nulos e define valores padrão
    final senderPhotoUrl = data?['senderPhotoUrl'];
    final senderName = data?['senderName'];
    final messageText = data?['text'] ?? '';
    final base64Image = data?['base64img'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          !mine ?
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(senderPhotoUrl),
            ),
          ) : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (base64Image != null)
                  Image.memory(base64Decode(base64Image), width: 200,)
                else if (messageText.isNotEmpty)
                  Text(
                    messageText,
                    textAlign: mine ? TextAlign.end : TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                Text(
                  senderName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          mine ?
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(senderPhotoUrl),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}

