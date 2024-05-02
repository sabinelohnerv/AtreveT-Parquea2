import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/user_vehicle_details_viewmodel.dart';
import 'package:provider/provider.dart';

class VehicleDetails extends StatelessWidget {
  final String vehicleId;
  final String userId;

  const VehicleDetails({super.key, required this.vehicleId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehicleDetailsViewModel()..loadVehicle(vehicleId, userId),
      child: Consumer<VehicleDetailsViewModel>(
        builder: (context, viewModel, child) {
          var vehicle = viewModel.vehicle;
          if (vehicle == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                vehicle.id,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vehicle.make),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
