import 'package:flutter/material.dart';
import 'package:parquea2/views/add_vehicle_view.dart';
import 'package:parquea2/views/client_garage_list_view.dart';
import 'package:parquea2/views/client_offer_list_view.dart';
import 'package:parquea2/views/map_view.dart';
import 'package:parquea2/views/provider_garage_list_view.dart';
import 'package:parquea2/views/provider_offer_list_view.dart';
import 'package:parquea2/views/user_vehicles_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parquea2/views/login_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key});

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  @override
  Widget build(BuildContext context) {
    _markOnboardingComplete();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 188, 7),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginView(userType: UserType.client)),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 7),
              ),
              child: const Text(
                'Vehículos',
                style: TextStyle(color: Colors.white),
              ),
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
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProviderOfferListView()),
                )
              },
              child: const Text('Ofertas (Proveedores)'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientOfferListView()),
                )
              },
              child: const Text('Ofertas (Clientes)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/mapScreen');
              },
              child: Text('Mapa de Garajes (Clientes)'),
            )
          ],
        ),
      ),
    );
  }
}
