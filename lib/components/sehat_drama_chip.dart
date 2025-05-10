import 'package:flutter/material.dart';

class SehatDramaChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final String imagePath;

  const SehatDramaChip({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFF44336),
    this.imagePath = 'assets/placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        avatar: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          backgroundColor: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}