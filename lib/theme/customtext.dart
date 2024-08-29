import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final TextAlign alignment;
  final Color color;
  final String fontFamily;
  final double letterSpacing;

  const CustomText({
    super.key,
    required this.text,
    this.size = 16.0, // Default size
    this.weight = FontWeight.normal, // Default weight
    this.alignment = TextAlign.left, // Default alignment
    this.color = Colors.black, // Default color
    this.fontFamily = "Poppins", // Default font family
    this.letterSpacing = 0.0, // Default letter spacing
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFamily: fontFamily, // Specify the font family
        letterSpacing: letterSpacing, // Add letter spacing
      ),
    );
  }
}