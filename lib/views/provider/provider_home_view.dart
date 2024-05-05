import 'package:flutter/material.dart';
import 'package:parquea2/views/provider/provider_garage_list_view.dart';
import 'package:parquea2/views/provider/provider_garage_offer_list_view.dart';
import 'package:parquea2/views/provider/provider_reservation_garage_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parquea2/views/login_view.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

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
                MaterialPageRoute(builder: (context) => const LoginView()),
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
                      builder: (context) =>
                          const ProviderGarageOffersListView()),
                )
              },
              child: const Text('Ofertas (Proveedores)'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OfferGarageListView()),
                )
              },
              child: const Text('Reservas (Proveedores)'),
            ),
          ],
        ),
      ),
    );
  }
}
