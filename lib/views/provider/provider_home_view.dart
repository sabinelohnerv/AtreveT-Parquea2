import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider/provider_viewmodel.dart';
import 'package:parquea2/views/login_view.dart';
import 'package:parquea2/views/provider/provider_garage_list_view.dart';
import 'package:parquea2/views/provider/provider_garage_offer_list_view.dart';
import 'package:parquea2/views/provider/provider_reservation_garage_list_view.dart';
import 'package:parquea2/views/widgets/drawers/provider/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  void _handleSignOut(BuildContext context, ProviderViewModel viewModel) async {
    bool signedOut = await viewModel.signOut();
    if (signedOut) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<ProviderViewModel>(context);
    userViewModel.loadCurrentProvider();
    _markOnboardingComplete();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PARKEADO',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(
        fullName:
            userViewModel.currentProvider?.fullName ?? 'Nombre desconocido',
        email: userViewModel.currentProvider?.email ?? 'Email desconocido',
        phoneNumber: userViewModel.currentProvider?.phoneNumber ??
            'Teléfono desconocido',
        onSignOut: () => _handleSignOut(context, userViewModel),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReservationGarageListView()),
                              );
                            },
                            child: const Card(
                              child: SizedBox(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/reservation.png'),
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Reservas',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProviderGarageOffersListView()),
                              );
                            },
                            child: const Card(
                              child: SizedBox(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/negociacion.png'),
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Ofertas',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GarageListView()),
                        );
                      },
                      child: Card(
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/garaje.png'),
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Garajes',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "¡Bienvenido, ${userViewModel.currentProvider?.fullName ?? 'Usuario'}!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
