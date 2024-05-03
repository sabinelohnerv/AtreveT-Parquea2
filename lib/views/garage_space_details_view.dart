import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/garage_space_details_viewmodel.dart';
import 'package:provider/provider.dart';

class GarageSpaceDetails extends StatelessWidget {
  final String garageId;
  final String spaceId;

  const GarageSpaceDetails(
      {super.key, required this.garageId, required this.spaceId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          GarageSpaceDetailsViewModel()..loadGarageSpace(garageId, spaceId),
      child: Consumer<GarageSpaceDetailsViewModel>(
        builder: (context, viewModel, child) {
          var garageSpace = viewModel.garageSpace;
          if (garageSpace == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'ESPACIOS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              foregroundColor: Colors.white,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => Provider.of<GarageSpaceDetailsViewModel>(
                          context,
                          listen: false)
                      .navigateToEditGarageSpace(context, garageId),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(garageSpace.id),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
