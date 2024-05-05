import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider/provider_reservation_list_viewmodel.dart';
import 'package:parquea2/views/widgets/reservations/provider_reservation_card.dart';
import 'package:provider/provider.dart';

class ProviderReservationListView extends StatelessWidget {
  final String garageId;
  const ProviderReservationListView({super.key, required this.garageId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderReservationListViewModel>(
      create: (_) => ProviderReservationListViewModel(garageId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RESERVAS',
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
        body: Consumer<ProviderReservationListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.reservations.isEmpty) {
              return const Center(child: Text('No hay reservas activas.'));
            }
            return ListView.builder(
              itemCount: viewModel.reservations.length,
              itemBuilder: (context, index) {
                final reservation = viewModel.reservations[index];
                int spaceNumber =
                    viewModel.getSpaceIndex(reservation.garageSpace.spaceId);
                return ProviderReservationCard(
                  reservation: reservation,
                  reservationNumber: index + 1,
                  spaceNumber: spaceNumber,
                  onTap: () => viewModel.navigateToReservationDetails(
                      context, reservation.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
