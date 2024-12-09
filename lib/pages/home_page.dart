import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: TextComposer(sendMessage: _sendMessage),
    );
  }

  void _sendMessage({String? text, File? image}) async {
    final Map<String, dynamic> data = {};

    if (image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final uploadTask = storageRef.putFile(image);

      try {
        final taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();
        data['imageUrl'] = imageUrl;
      } catch (error) {
        /*
         Gera uma URL para uma imagem aleatórioa de teste,
         para caso não tenha acesso ao Storage do Firebase.
         */
        data['text'] = error.toString();
        data['imageUrl'] = 'https://picsum.photos/500/500';
      }
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }
}