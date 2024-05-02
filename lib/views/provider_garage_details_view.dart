import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider_garage_details_viewmodel.dart';
import 'package:provider/provider.dart';

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
            appBar: AppBar(
              title: Text(
                garage.name,
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
                  Text(garage.name),
                  ElevatedButton(
                      onPressed: () {
                        viewModel.navigateToGarageSpaces(context, garageId);
                      },
                      child: const Text('Gestionar Espacios'))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
