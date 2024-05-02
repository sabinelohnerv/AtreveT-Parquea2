import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:parquea2/views/add_garage_view.dart';
import 'package:parquea2/views/add_vehicle_view.dart';
>>>>>>> 0c5d1b831507c8c23af1866cefdd2dc3a864b763
import 'package:parquea2/views/provider_garage_list_view.dart';
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
<<<<<<< HEAD
=======
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddGarageView()),
                )
              },
              child: const Text('Agregar Garaje'),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddVehicleView()),
                )
              },
              child: const Text('Agregar Vehiculo'),
            ),
          ],
>>>>>>> 0c5d1b831507c8c23af1866cefdd2dc3a864b763
        child: ElevatedButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GarageListView()),
            )
          },
          child: const Text('Agregar Garaje'),
        ),
      ),
    );
  }
}
