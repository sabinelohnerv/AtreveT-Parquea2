import 'package:flutter/material.dart';
import 'package:parquea2/views/add_vehicle_view.dart';
import 'package:parquea2/views/client_garage_list_view.dart';
import 'package:parquea2/views/provider_garage_list_view.dart';
import 'package:parquea2/views/user_vehicles_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  @override
  Widget build(BuildContext context) {
    _markOnboardingComplete();
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VehicleListView()),
                )
              },
              child: const Text('Vehículos'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GarageListView()),
                )
              },
              child: const Text('Garajes (Proveedores)'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientGarageListView()),
                )
              },
              child: const Text('Garajes (Clientes)'),
            ),

          ],
        ),
      ),
    );
  }
}
