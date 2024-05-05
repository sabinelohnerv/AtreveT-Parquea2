import 'package:flutter/material.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/viewmodels/client/client_garage_list_viewmodel.dart';
import 'package:parquea2/views/widgets/garages/garage_card.dart';
import 'package:provider/provider.dart';

class ClientGarageListView extends StatelessWidget {
  const ClientGarageListView({super.key});

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
      ),
      body: ChangeNotifierProvider<ClientGarageListViewModel>(
        create: (context) => ClientGarageListViewModel(),
        child: Consumer<ClientGarageListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.garages.isEmpty) {
              return const Center(
                  child: Text('No se encontraron garajes.'));
            }
            return ListView.builder(
              itemCount: viewModel.garages.length,
              itemBuilder: (context, index) {
                final garage = viewModel.garages[index];
                return GarageCard(
                  garage: garage,
                  garageService: GarageService(),
                  onTap: () {
                    viewModel.navigateToGarageDetails(context, garage);
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
