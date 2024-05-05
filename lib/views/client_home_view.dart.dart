import 'package:flutter/material.dart';
import 'package:parquea2/views/map_view.dart';

class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 188, 7),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
      ),
      body: const Column(
        children: [
          Expanded(
            flex: 8,
            child: MapScreen(),
          ),
        ],
      ),
    );
  }
}
