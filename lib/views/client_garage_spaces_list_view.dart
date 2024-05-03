import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/viewmodels/client_garage_spaces_list_viewmodel.dart';
import 'package:parquea2/views/widgets/garages/client_garage_space_card.dart';
import 'package:parquea2/views/widgets/garages/client_garage_space_details.dart';
import 'package:provider/provider.dart';

class ClientGarageSpacesListView extends StatelessWidget {
  final Garage garage;
  const ClientGarageSpacesListView({super.key, required this.garage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientGarageSpacesListViewModel>(
      create: (_) => ClientGarageSpacesListViewModel(garage.id, GarageService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ESPACIOS DE GARAJE',
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
        ),
        body: Consumer<ClientGarageSpacesListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.garageSpaces.isEmpty) {
              return const Center(child: Text('No hay espacios registrados.'));
            }
            return ListView.builder(
              itemCount: viewModel.garageSpaces.length,
              itemBuilder: (context, index) {
                final garageSpace = viewModel.garageSpaces[index];
                return ClientGarageSpaceCard(
                    garageSpace: garageSpace,
                    garageNumber: index + 1,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ClientGarageSpaceDetails(
                            garageSpace: garageSpace,
                            garage: garage,
                            spaceNumber: index + 1,
                          );
                        },
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
