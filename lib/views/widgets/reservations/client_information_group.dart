import 'package:flutter/material.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_item.dart';

class ClientInformationGroup extends StatelessWidget {
  final String title;
  final List<InformationItem> items;
  final IconData? icon;
  final VoidCallback onTap;

  const ClientInformationGroup({
    super.key,
    required this.title,
    required this.items,
    required this.onTap,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/wpp.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CONTACTAR',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
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
