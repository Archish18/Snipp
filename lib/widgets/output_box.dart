import 'package:flutter/material.dart';

class OutputBox extends StatelessWidget {
  final String title;
  final String content;

  const OutputBox({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$title:\n$content",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
