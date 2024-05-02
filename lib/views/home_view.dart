import 'package:flutter/material.dart';
import 'package:parquea2/views/add_vehicle_view.dart';
import 'package:parquea2/views/provider_garage_list_view.dart';
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
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView(userType: UserType.client)),
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
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
              child: Text(
                'Vehículos',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 7),
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
              child: Text(
                'Garajes',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
