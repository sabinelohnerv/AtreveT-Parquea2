import 'package:flutter/material.dart';
import 'package:parquea2/views/client/client_garage_list_view.dart';
import 'package:parquea2/views/client/client_offer_list_view.dart';
import 'package:parquea2/views/client/client_reservation_list_view.dart';
import 'package:parquea2/views/client/client_vehicles_list_view.dart';
import 'package:parquea2/views/widgets/drawers/client/drawer_body.dart';
import 'package:parquea2/views/widgets/drawers/client/drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  final String fullName;
  final String email;
  final VoidCallback onSignOut;

  const CustomDrawer({
    super.key,
    required this.fullName,
    required this.email,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ClientDrawerHeaderWidget(
            fullName: fullName,
            email: email,
          ),
          ClientDrawerBodyWidget(
            onReservationTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClientReservationListView()),
              );
            },
            onOfferTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClientOfferListView()),
              );
            },
            onGarageTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClientGarageListView()),
              );
            },
            onVehicleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VehicleListView()),
              );
            },
            onSignOut: onSignOut,
          ),
        ],
      ),
    );
  }
}
