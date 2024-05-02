import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/garage_spaces_list_viewmodel.dart';
import 'package:provider/provider.dart';

class GarageSpacesListView extends StatelessWidget {
  final String garageId;
  const GarageSpacesListView({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Espacios de Garaje',
          style: TextStyle(color: Colors.white),
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
            onPressed: () => GarageSpacesListViewModel(garageId)
                .navigateToAddGarageSpace(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider<GarageSpacesListViewModel>(
        create: (context) => GarageSpacesListViewModel(garageId),
        child: Consumer<GarageSpacesListViewModel>(
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
                return Text('$index - ${garageSpace.measurements.height}');
              },
            );
          },
        ),
      ),
    );
  }
}
