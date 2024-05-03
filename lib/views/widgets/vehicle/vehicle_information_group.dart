import 'package:flutter/material.dart';

import 'vehicle_information_item.dart';

class InformationGroup extends StatelessWidget {
  final String title;
  final List<InformationItem> items;
  final IconData? icon;

  const InformationGroup({
    super.key,
    required this.title,
    required this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
          if (icon != null) const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Divider(height: 30),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: item,
              )),
        ],
      ),
    );
  }
}
