import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider_garage_details_viewmodel.dart';
import 'package:provider/provider.dart';

import 'widgets/garages/garage_tile.dart';

class GarageDetails extends StatelessWidget {
  final String garageId;

  const GarageDetails({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GarageDetailsViewModel()..loadGarage(garageId),
      child: Consumer<GarageDetailsViewModel>(
        builder: (context, viewModel, child) {
          var garage = viewModel.garage;
          if (garage == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30)),
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              garage.imgUrl ?? 'path/to/default/image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          garage.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          garage.location.location,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InformationTile(
                                title: "Valoracion",
                                value: garage.rating.toString(),
                                icon: Icons.star),
                            InformationTile(
                                title: "Espacios",
                                value: garage.numberOfSpaces.toString(),
                                icon: Icons.garage),
                            InformationTile(
                                title: "Reservas",
                                value: garage.reservationsCompleted.toString(),
                                icon: Icons.group_rounded),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: garage.details!
                                .map((detail) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Chip(label: Text(detail)),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "${garage.location.coordinates}\n${garage.location.location}\n${garage.location.reference}",
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w300),
                            ),
                          ),
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
