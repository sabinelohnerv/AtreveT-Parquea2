import 'package:flutter/material.dart';
import 'package:parquea2/views/provider/provider_garage_list_view.dart';
import 'package:parquea2/views/provider/provider_garage_offer_list_view.dart';
import 'package:parquea2/views/provider/provider_reservation_garage_list_view.dart';
import 'package:parquea2/views/widgets/drawers/provider/drawer_body.dart';
import 'package:parquea2/views/widgets/drawers/provider/drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final VoidCallback onSignOut;

  const CustomDrawer({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ProviderDrawerHeaderWidget(
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
          ),
          ProviderDrawerBodyWidget(
            onReservationTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReservationGarageListView()),
              );
            },
            onOfferTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProviderGarageOffersListView()),
              );
            },
            onGarageTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GarageListView()),
              );
            },
            onSignOut: onSignOut,
          ),
        ],
      ),
    );
  }
}
