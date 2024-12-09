import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key, required this.sendMessage});

  final Function({String text, File image}) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _handleMessageSend() {
    widget.sendMessage(text: _controller.text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  Future<void> _handleImageSend() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      widget.sendMessage(image: File(pickedFile.path));
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _handleImageSend,
          icon: const Icon(Icons.photo_camera),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration.collapsed(hintText: "Mensagem"),
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              _handleMessageSend();
            },
          ),
        ),
        IconButton(
            onPressed: _isComposing ? _handleMessageSend : null,
            icon: const Icon(Icons.send)),
      ],
    );
  }
}