import 'package:flutter/material.dart';

class ClientDrawerHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;

  const ClientDrawerHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(
          top: 30 + MediaQuery.of(context).padding.top, bottom: 30),
      child: Column(
        children: [
          Text(
            fullName,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
