import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/user_vehicle_details_viewmodel.dart';
import 'package:provider/provider.dart';

import 'widgets/vehicle/vehicle_details_card.dart';
import 'widgets/vehicle/vehicle_information_group.dart';
import 'widgets/vehicle/vehicle_information_item.dart';

class VehicleDetailsView extends StatelessWidget {
  final String vehicleId;
  final String userId;

  const VehicleDetailsView(
      {super.key, required this.vehicleId, required this.userId});

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
              title: const Text(
                'VEHICULOS',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: VehicleDetailsCard(
                      vehicle: vehicle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        InformationGroup(
                          title: 'INFORMACION',
                          items: [
                            InformationItem(
                              label: 'Marca:',
                              value: vehicle.make.toUpperCase(),
                              leadingIcon: Icons.car_repair,
                            ),
                            InformationItem(
                              label: 'Modelo:',
                              value: vehicle.model.toUpperCase(),
                              leadingIcon: Icons.car_rental_sharp,
                            ),
                            InformationItem(
                              label: 'Placa:',
                              value: vehicle.plateNumber.toUpperCase(),
                              leadingIcon: Icons.numbers,
                            ),
                            InformationItem(
                              label: 'Año:',
                              value: vehicle.year.toString(),
                              leadingIcon: Icons.calendar_today,
                            ),
                          ],
                        ),
                        InformationGroup(
                          title: 'MEDIDAS',
                          items: [
                            InformationItem(
                              label: 'Alto:',
                              value: '${vehicle.measurements.height} METROS',
                              leadingIcon: Icons.arrow_upward,
                            ),
                            InformationItem(
                              label: 'Ancho:',
                              value: '${vehicle.measurements.width} METROS',
                              leadingIcon: Icons.width_full,
                            ),
                            InformationItem(
                              label: 'Largo:',
                              value: '${vehicle.measurements.length} METROS',
                              leadingIcon: Icons.straighten,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
