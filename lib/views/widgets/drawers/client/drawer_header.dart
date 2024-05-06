import 'package:flutter/material.dart';

class ClientDrawerHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final double rating;
  const ClientDrawerHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
    required this.rating,
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
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 4),
              Text(
                rating == 0 ? 'N/A' : rating.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Icon(Icons.star, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
