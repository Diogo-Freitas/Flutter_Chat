import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessageStream() {
    return _firestore.collection('messages').snapshots();
  }

  Future<void> sendMessage({
    required Map<String, dynamic> data,
    File? image,
  }) async {
    if (image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final uploadTask = await storageRef.putFile(image);
      data['imageUrl'] = await uploadTask.ref.getDownloadURL();
    }

    await _firestore
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(data);
  }
}
