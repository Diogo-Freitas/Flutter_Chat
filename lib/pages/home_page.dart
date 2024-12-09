import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/widgets/text_composer.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _sendMessage(String text) {
    FirebaseFirestore.instance.collection('messages').add({'text': text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: TextComposer(sendMessage: (text) {
        _sendMessage(text);
      }),
    );
  }
}