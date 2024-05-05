import 'package:flutter/material.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/views/client/client_vehicle_details_view.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final String userId;

  const VehicleCard({super.key, required this.vehicle, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VehicleDetailsView(vehicleId: vehicle.id, userId: userId),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 2.0,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                height: 515,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      image:
                          vehicle.imgUrl != null && vehicle.imgUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(vehicle.imgUrl!),
                                  fit: BoxFit.contain,
                                )
                              : null,
                      color: vehicle.imgUrl == null || vehicle.imgUrl!.isEmpty
                          ? Colors.grey.shade300
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: vehicle.imgUrl == null || vehicle.imgUrl!.isEmpty
                        ? const Icon(Icons.business,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${vehicle.make} - ${vehicle.model}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    vehicle.plateNumber.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
