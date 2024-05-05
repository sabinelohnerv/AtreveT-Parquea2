import 'package:flutter/material.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/viewmodels/provider/provider_garage_list_viewmodel.dart';
import 'package:parquea2/views/widgets/garages/garage_card.dart';
import 'package:provider/provider.dart';

class GarageListView extends StatelessWidget {
  const GarageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GARAJES',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Provider.of<GarageListViewModel>(context, listen: false)
                    .navigateToAddGarage(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider<GarageListViewModel>(
        create: (context) => GarageListViewModel(),
        child: Consumer<GarageListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.garages.isEmpty) {
              return const Center(child: Text('No se encontraron garajes.'));
            }
            return ListView.builder(
              itemCount: viewModel.garages.length,
              itemBuilder: (context, index) {
                final garage = viewModel.garages[index];
                return GarageCard(
                  garage: garage,
                  garageService: GarageService(),
                  onTap: () {
                    viewModel.navigateToGarageDetails(context, garage.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
