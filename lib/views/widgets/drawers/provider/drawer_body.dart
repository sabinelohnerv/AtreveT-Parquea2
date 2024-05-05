import 'package:flutter/material.dart';

class ProviderDrawerBodyWidget extends StatelessWidget {
  final VoidCallback onGarageTap;
  final VoidCallback onReservationTap;
  final VoidCallback onOfferTap;
  final VoidCallback onSignOut;

  const ProviderDrawerBodyWidget({
    super.key,
    required this.onGarageTap,
    required this.onReservationTap,
    required this.onOfferTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Mis Garajes'),
            onTap: onGarageTap,
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Ofertas Activas'),
            onTap: onOfferTap,
          ),
          ListTile(
            leading: const Icon(Icons.local_parking),
            title: const Text('Reservas Activas'),
            onTap: onReservationTap,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
