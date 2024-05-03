import 'package:flutter/material.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/viewmodels/client_garage_spaces_list_viewmodel.dart';
import 'package:parquea2/views/widgets/garages/garage_space_card.dart';
import 'package:provider/provider.dart';

class ClientGarageSpacesListView extends StatelessWidget {
  final String garageId;
  const ClientGarageSpacesListView({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientGarageSpacesListViewModel>(
      create: (_) => ClientGarageSpacesListViewModel(garageId, GarageService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Espacios de Garaje',
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
                return GarageSpaceCard(
                    garageSpace: garageSpace,
                    garageNumber: index + 1,
                    onDelete: () {});
              },
            );
          },
        ),
      ),
    );
  }
}
