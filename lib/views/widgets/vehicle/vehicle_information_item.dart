import 'package:flutter/material.dart';

class InformationItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? leadingIcon;

  const InformationItem({
    super.key,
    required this.label,
    required this.value,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingIcon != null)
          Icon(
            leadingIcon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        if (leadingIcon != null) const SizedBox(width: 8),
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
