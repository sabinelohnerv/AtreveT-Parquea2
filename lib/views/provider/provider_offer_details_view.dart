import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/offer_details_viewmodel.dart';
import 'package:parquea2/views/widgets/buttons/footer_buttons.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_item.dart';
import 'package:provider/provider.dart';

import '../../services/whatsapp_service.dart';

class ProviderOfferDetailsView extends StatelessWidget {
  final String offerId;

  const ProviderOfferDetailsView({super.key, required this.offerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OfferDetailsViewModel()..loadOffer(offerId),
      child: Consumer<OfferDetailsViewModel>(
        builder: (context, viewModel, child) {
          var offer = viewModel.offer;
          if (offer == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('OFERTA',
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
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            child: InkWell(
                              onTap: () => viewModel.decrementOfferAmount(1),
                              onLongPress: () =>
                                  viewModel.decrementOfferAmount(5),
                              child: Ink(
                                child: const RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              'BOB ${viewModel.localOfferAmount.toStringAsFixed(1)}',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Material(
                            child: InkWell(
                              onTap: () => viewModel.incrementOfferAmount(1),
                              onLongPress: () =>
                                  viewModel.incrementOfferAmount(5),
                              child: Ink(
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.green,
                                  size: 45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (offer.state != 'rejected-by-client')
                        ? (offer.provider.id != offer.lastOfferBy)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        viewModel.submitCounterOffer(
                                      offer.id,
                                      offer.provider.id,
                                    ),
                                    label: const Text(
                                      'CONTRAOFERTA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child:
                                    Text('Espera una respuesta del cliente...'),
                              )
                        : const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 4),
                            child: Text(
                              'OFERTA RECHAZADA POR EL CLIENTE',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                              maxLines: 3,
                            ),
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (viewModel.clientPhoneNumber != null) {
                          WhatsAppService().sendMessage(
                              viewModel.clientPhoneNumber!,
                              "Quisiera discutir la negociación del garaje ${offer.garageSpace.garageName}");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Numero no disponible actualmente"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/wpp.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CONTACTAR',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InformationGroup(
                      title: 'CLIENTE',
                      items: [
                        InformationItem(
                            label: 'Nombre:',
                            value: offer.client.fullName.toUpperCase(),
                            leadingIcon: Icons.person),
                        InformationItem(
                            label: 'Rating:',
                            value: offer.client.rating.toString(),
                            leadingIcon: Icons.star),
                        InformationItem(
                            label: 'Placa:',
                            value: offer.vehicle.plateNumber.toUpperCase(),
                            leadingIcon: Icons.numbers),
                      ],
                    ),
                    InformationGroup(
                      title: 'TIEMPO',
                      items: [
                        InformationItem(
                            label: 'Comienzo:',
                            value: offer.time.startTime,
                            leadingIcon: Icons.access_time),
                        InformationItem(
                            label: 'Fin:',
                            value: offer.time.endTime,
                            leadingIcon: Icons.hourglass_bottom),
                        InformationItem(
                            label: 'Fecha:',
                            value: offer.date,
                            leadingIcon: Icons.calendar_month),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              if (offer.state != 'rejected-by-client')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomFooterButton(
                        iconData: Icons.close_sharp,
                        label: 'RECHAZAR',
                        onPressed: () {
                          _onReject(context, viewModel);
                        },
                        color: Colors.red),
                    CustomFooterButton(
                        iconData: Icons.check_sharp,
                        label: 'ACEPTAR',
                        onPressed: () {
                          _onAccept(context, viewModel);
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

  void _onAccept(BuildContext context, OfferDetailsViewModel viewModel) async {
    if (viewModel.offer!.lastOfferBy == viewModel.offer!.provider.id) {
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Acción Denegada'),
              content: const Text(
                  'No puedes aceptar una oferta que no ha sido aceptada por el cliente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Entendido'),
                ),
              ],
            );
          });
    } else {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Confirmar Acción'),
            content: const Text(
                '¿Estás seguro de que quieres aceptar esta oferta y crear una reserva?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        bool result = await viewModel.createReservation();
        if (result) {
          viewModel.showSnackbar(
              context, 'Reserva creada exitosamente', Colors.green);
          Navigator.of(context).pop();
        } else {
          viewModel.showSnackbar(
              context, 'Error al crear la reserva.', Colors.red);
        }
      } else {
        viewModel.showSnackbar(
            context, 'Creación de reserva cancelada.', Colors.grey.shade700);
      }
    }
  }

  void _onReject(BuildContext context, OfferDetailsViewModel viewModel) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Rechazo'),
          content:
              const Text('¿Estás seguro de que quieres rechazar esta oferta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await viewModel.updateOfferState(
          viewModel.offer!.id, 'rejected-by-provider');
      viewModel.showSnackbar(context, 'Oferta rechazada.', Colors.red);
      Navigator.of(context).pop();
    }
  }
}
