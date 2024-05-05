import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/provider_reservation_garage_list_viewmodel.dart';
import 'package:parquea2/views/widgets/reservations/provider_reservation_garage_card.dart';
import 'package:provider/provider.dart';

class OfferGarageListView extends StatelessWidget {
  const OfferGarageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RESERVAS POR GARAJE',
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
      body: ChangeNotifierProvider<ReservationGarageListViewModel>(
        create: (context) => ReservationGarageListViewModel(),
        child: Consumer<ReservationGarageListViewModel>(
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
                int reservationCount =
                    viewModel.reservationCounts[garage.id] ?? 0;

                return ReservationGarageCard(
                  garage: garage,
                  reservationCount: reservationCount,
                  onTap: () => viewModel.navigateToReservationsPerGarage(context, garage.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
