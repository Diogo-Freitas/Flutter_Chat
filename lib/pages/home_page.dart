import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/chat_message.dart';
import '../widgets/text_composer.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();

  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user){
      setState(() {
        _user = user;
      });
    });
  }

  void _sendMessage({String? text, File? image}) async {

    setState(() {
      _isLoading = true;
    });

    _user ??= await _authService.signInWithGoogle();

    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer login.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      'uid': _user!.uid,
      'senderName': _user!.displayName,
      'senderPhotoUrl': _user!.photoURL,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firebaseService.sendMessage(data: data, image: image);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          _user?.displayName ?? widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          _user != null
              ? IconButton(
                  onPressed: (){
                    _authService.signOutWithGoogle();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Você saiu  com sucesso!.'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ))
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMessageStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    return ChatMessage(data: data, mine: data['uid'] == _user?.uid);
                  },
                );
              },
            ),
          ),
          _isLoading ? const LinearProgressIndicator() : Container(),
          TextComposer(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}
