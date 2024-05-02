import 'package:flutter/material.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/viewmodels/user_vehicles_list_viewmodel.dart';
import 'package:provider/provider.dart';

class VehicleListView extends StatelessWidget {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VehicleListViewModel>(
      create: (_) => VehicleListViewModel(VehicleService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vehículos Registrados',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Provider.of<VehicleListViewModel>(context, listen: false)
                    .navigateToAddVehicle(context),
            )
          ],
        ),
        body: Consumer<VehicleListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.vehicles.isEmpty) {
              return const Center(child: Text('No hay vehículos registrados.'));
            }
            return ListView.builder(
              itemCount: viewModel.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = viewModel.vehicles[index];
                return Text(vehicle.make);
              },
            );
          },
        ),
      ),
    );
  }
}
