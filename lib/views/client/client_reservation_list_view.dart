import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/client/client_reservation_list_viewmodel.dart';
import 'package:parquea2/views/widgets/reservations/reservation_card.dart';
import 'package:provider/provider.dart';

class ClientReservationListView extends StatelessWidget {
  const ClientReservationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RESERVAS',
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
      body: ChangeNotifierProvider<ClientReservationListViewModel>(
        create: (context) => ClientReservationListViewModel(),
        child: Consumer<ClientReservationListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.reservations.isEmpty) {
              return const Center(
                  child: Text('No se encontraron reservas activas.'));
            }
            return ListView.builder(
              itemCount: viewModel.reservations.length,
              itemBuilder: (context, index) {
                final reservation = viewModel.reservations[index];
                return ReservationCard(
                  reservation: reservation,
                  reservationNumber: index + 1,
                  onTap: () {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
