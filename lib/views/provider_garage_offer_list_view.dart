import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/garage_service.dart';
import '../viewmodels/provider_garage_list_viewmodel.dart';
import 'provider_offers_list_view.dart';
import 'widgets/garages/provider_garage_offer_card.dart';

class ProviderGarageOffersListView extends StatelessWidget {
  const ProviderGarageOffersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OFERTAS POR GARAJE',
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
                return GarageOfferCard(
                  garage: garage,
                  garageService: GarageService(),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProviderOffersListView(
                                  garageId: garage.id,
                                )));
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
