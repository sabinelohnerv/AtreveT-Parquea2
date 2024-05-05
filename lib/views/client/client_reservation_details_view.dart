import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parquea2/viewmodels/reservation_details_viewmodel.dart';
import 'package:parquea2/views/widgets/buttons/footer_buttons.dart';
import 'package:parquea2/views/widgets/reservations/client_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_item.dart';
import 'package:provider/provider.dart';

import '../../services/whatsapp_service.dart';

class ClientReservationDetailsView extends StatelessWidget {
  final String reservationId;

  const ClientReservationDetailsView({super.key, required this.reservationId});

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
          stateText = 'GARAJE CALIFICADO';
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
                    ClientInformationGroup(
                      title: 'GARAJE',
                      onTap: () {
                        if (viewModel.providerPhoneNumber != null) {
                          WhatsAppService().sendMessage(
                              viewModel.providerPhoneNumber!,
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
                            value: reservation.garageSpace.garageName,
                            leadingIcon: Icons.business),
                        InformationItem(
                            label: 'Número:',
                            value: viewModel.providerPhoneNumber != null
                                ? viewModel.providerPhoneNumber!
                                : '',
                            leadingIcon: Icons.phone),
                      ],
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
                                reservationId, 'cancelled-by-client');
                            viewModel.updateGarageSpaceState(
                              viewModel.reservation!.garageSpace.garageId,
                              viewModel.reservation!.garageSpace.spaceId,
                              'libre',
                            );
                            Navigator.of(context).pop();
                          },
                          color: Colors.red),
                    if (viewModel.reservation!.state == 'cancelled-by-provider')
                      CustomFooterButton(
                          iconData: Icons.check_sharp,
                          label: 'ENTENDIDO',
                          onPressed: () {
                            viewModel.updateReservationState(
                                reservationId, 'cancelled');
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue),
                    if (viewModel.reservation!.state == 'needs-rating')
                      CustomFooterButton(
                          iconData: Icons.star,
                          label: 'CALIFICAR',
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext dialogContext) {
                                  return _buildRatingDialog(
                                      context, viewModel, reservationId);
                                });
                          },
                          color: Colors.amber),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingDialog(BuildContext context,
      ReservationDetailsViewModel viewModel, String reservationId) {
    final TextEditingController ratingController = TextEditingController();

    return AlertDialog(
      title: const Text('Califica al Garaje'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Por favor califique al garaje de 1 a 5 estrellas.'),
          TextField(
            controller: ratingController,
            decoration: const InputDecoration(
              labelText: 'Rating (1-5)',
              hintText: 'Introduce un número entre 1 y 5',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'[1-5]')),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Enviar'),
          onPressed: () {
            final double rating = double.tryParse(ratingController.text) ?? 0;
            if (rating >= 1 && rating <= 5) {
              viewModel.finalizeReservationClient(context, reservationId,
                  viewModel.reservation!.garageSpace.garageId, rating);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Por favor ingresa una calificación válida entre 1 y 5.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
