import 'package:flutter/material.dart';

class SehatDramaChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final String imagePath;

  const SehatDramaChip({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFD32F2F),
    this.imagePath = 'assets/images/placeholder.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
              errorBuilder:
                  (_, __, ___) =>
                      Icon(Icons.image, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
