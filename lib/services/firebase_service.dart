import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessageStream() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required Map<String, dynamic> data,
    File? image,
  }) async {
    if (image != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        final uploadTask = await storageRef.putFile(image);
        data['imageUrl'] = await uploadTask.ref.getDownloadURL();
      } catch (error) {
        /*
         Gera uma URL para uma imagem aleatórioa de teste,
         para caso não tenha acesso ao Storage do Firebase.
         */
        data['text'] = 'Falha ao enviar imagem: ${error.toString()}';
        data['imageUrl'] = 'https://picsum.photos/500/500';
      }
    }

    data['timestamp'] = FieldValue.serverTimestamp();

    await _firestore.collection('messages').add(data);
  }
}
