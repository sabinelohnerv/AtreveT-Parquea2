import 'package:flutter/material.dart';

class ProviderDrawerHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  const ProviderDrawerHeaderWidget(
      {super.key,
      required this.fullName,
      required this.email,
      required this.phoneNumber});

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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, color: Colors.white, size: 20,),
              const SizedBox(width: 4),
              Text(
                phoneNumber,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
