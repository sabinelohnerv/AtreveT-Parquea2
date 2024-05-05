import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/reservation_details_viewmodel.dart';
import 'package:parquea2/views/widgets/buttons/footer_buttons.dart';
import 'package:parquea2/views/widgets/reservations/client_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_item.dart';
import 'package:provider/provider.dart';

import '../services/whatsapp_service.dart';

class ProviderReservationDetailsView extends StatelessWidget {
  final String reservationId;

  const ProviderReservationDetailsView(
      {super.key, required this.reservationId});

  @override
  Widget build(BuildContext context) {
    Widget determineState(String state) {
      Color textColor;
      String stateText;

      switch (state) {
        case 'active':
          textColor = Colors.blue;
          stateText = 'EN USO';
          break;
        case 'reserved':
          textColor = Colors.orange;
          stateText = 'RESERVADO';
          break;
        case 'cancelled-by-provider':
        case 'cancelled-by-client':
        case 'cancelled':
          textColor = Colors.red;
          stateText = 'CANCELADA';
          break;
        case 'finalized':
          textColor = Colors.blue;
          stateText = 'FINALIZADA';
          break;
        case 'needs-rating':
          textColor = Colors.green;
          stateText = 'FINALIZADA';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'DESCONOCIDO';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 26),
      );
    }

    return ChangeNotifierProvider(
      create: (_) =>
          ReservationDetailsViewModel()..loadReservation(reservationId),
      child: Consumer<ReservationDetailsViewModel>(
        builder: (context, viewModel, child) {
          var reservation = viewModel.reservation;
          if (reservation == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('RESERVA DE ESPACIO',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24)),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: determineState(reservation.state),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InformationGroup(
                      title: 'DETALLES',
                      items: [
                        InformationItem(
                            label: 'Horario:',
                            value:
                                '${reservation.time.startTime} - ${reservation.time.endTime}',
                            leadingIcon: Icons.access_time),
                        InformationItem(
                            label: 'Fecha:',
                            value: reservation.date,
                            leadingIcon: Icons.calendar_month),
                        InformationItem(
                            label: 'Precio:',
                            value: 'BOB ${reservation.payAmount.toString()}',
                            leadingIcon: Icons.monetization_on),
                      ],
                    ),
                    InformationGroup(
                      title: 'VEHÍCULO',
                      items: [
                        InformationItem(
                            label: 'Modelo:',
                            value:
                                '${reservation.vehicle.make} ${reservation.vehicle.model} (${reservation.vehicle.year.toString()})',
                            leadingIcon: Icons.directions_car_filled),
                        InformationItem(
                            label: 'Placa:',
                            value:
                                reservation.vehicle.plateNumber.toUpperCase(),
                            leadingIcon: Icons.numbers),
                      ],
                    ),
                    ClientInformationGroup(
                      title: 'CLIENTE',
                      onTap: () {
                        if (viewModel.clientPhoneNumber != null) {
                          WhatsAppService().sendMessage(
                              viewModel.clientPhoneNumber!,
                              "Quisiera discutir sobre la reserva del garaje ${reservation.garageSpace.garageName}");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Numero no disponible actualmente"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      items: [
                        InformationItem(
                            label: 'Nombre:',
                            value: reservation.client.fullName,
                            leadingIcon: Icons.person),
                        InformationItem(
                            label: 'Número:',
                            value: viewModel.clientPhoneNumber != null
                                ? viewModel.clientPhoneNumber!
                                : '',
                            leadingIcon: Icons.phone),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              if (viewModel.reservation != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (viewModel.reservation!.state == 'reserved')
                      CustomFooterButton(
                          iconData: Icons.close_sharp,
                          label: 'CANCELAR',
                          onPressed: () {
                            viewModel.updateReservationState(
                                reservationId, 'cancelled-by-provider');
                            viewModel.updateGarageSpaceState(
                              viewModel.reservation!.garageSpace.garageId,
                              viewModel.reservation!.garageSpace.spaceId,
                              'libre',
                            );
                            Navigator.of(context).pop();
                          },
                          color: Colors.red),
                    if (viewModel.reservation!.state == 'reserved')
                      CustomFooterButton(
                          iconData: Icons.local_parking,
                          label: 'EN USO',
                          onPressed: () {
                            viewModel.updateReservationState(
                                reservationId, 'active');
                            viewModel.updateGarageSpaceState(
                              viewModel.reservation!.garageSpace.garageId,
                              viewModel.reservation!.garageSpace.spaceId,
                              'ocupado',
                            );
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue),
                    if (viewModel.reservation!.state == 'active')
                      CustomFooterButton(
                          iconData: Icons.check_sharp,
                          label: 'FINALIZAR',
                          onPressed: () {
                            viewModel.showRatingDialog(
                                context,
                                viewModel,
                                reservation.client.id,
                                reservation.id,
                                reservation.garageSpace.garageId,
                                reservation.garageSpace.spaceId);
                            Navigator.of(context).pop();
                          },
                          color: Colors.green),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
