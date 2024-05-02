import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider_garage_list_viewmodel.dart';
import 'package:parquea2/views/widgets/garages/garage_card.dart';
import 'package:provider/provider.dart';

class GarageListView extends StatelessWidget {
  const GarageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garajes Registrados', style: TextStyle(fontWeight: FontWeight.w600),),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30, color: Colors.white,),
            onPressed: () =>
                Provider.of<GarageListViewModel>(context, listen: false)
                    .navigateToAddGarage(context),
          ),
        ],
      ),
      body: Consumer<GarageListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.garages.isEmpty) {
            return const Center(
                child: Text('Aún no tienes parqueos registrados'));
          }
          return ListView.builder(
            itemCount: viewModel.garages.length,
            itemBuilder: (context, index) {
              final garage = viewModel.garages[index];
              return GarageCard(
                garage: garage,
                onTap: () {
                  viewModel.navigateToGarageDetails(context, garage.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
