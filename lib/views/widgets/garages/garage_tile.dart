import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  const InformationTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w200),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
