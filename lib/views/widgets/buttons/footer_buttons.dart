import 'package:flutter/material.dart';

class CustomFooterButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const CustomFooterButton({
    super.key,
    required this.iconData,
    required this.label,
    required this.onPressed,
    required this.color,
    CircularProgressIndicator? child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconData, color: Colors.white),
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
