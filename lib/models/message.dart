class Message {
  final String? text;
  final String? imageUrl;
  final String? senderName;
  final String? senderPhotoUrl;

  Message({
    this.text,
    this.imageUrl,
    this.senderName,
    this.senderPhotoUrl,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'],
      imageUrl: map['imageUrl'],
      senderName: map['senderName'],
      senderPhotoUrl: map['senderPhotoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
    };
  }
}
