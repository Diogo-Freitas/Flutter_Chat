import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key, required this.sendMessage});

  final Function(String) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _handleSend() {
    widget.sendMessage(_controller.text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera)),
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
              _handleSend();
            },
          ),
        ),
        IconButton(
            onPressed: _isComposing ? _handleSend : null,
            icon: const Icon(Icons.send)),
      ],
    );
  }
}