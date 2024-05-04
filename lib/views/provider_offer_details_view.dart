import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/offer_details_viewmodel.dart';
import 'package:parquea2/views/widgets/buttons/footer_buttons.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_group.dart';
import 'package:parquea2/views/widgets/vehicle/vehicle_information_item.dart';
import 'package:provider/provider.dart';

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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    (offer.provider.id != offer.lastOfferBy)
                        ? ElevatedButton(
                            onPressed: () => viewModel.submitCounterOffer(
                              offer.id,
                              offer.provider.id,
                            ),
                            child: const Text('CONTRAOFERTA',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('Espera una respuesta del cliente...'),
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
        viewModel.showSnackbar(context, 'Reserva creada exitosamente', Colors.green);
        Navigator.of(context).pop();
      } else {
        viewModel.showSnackbar(context, 'Error al crear la reserva.', Colors.red);
      }
    } else {
      viewModel.showSnackbar(context, 'Creación de reserva cancelada.', Colors.grey.shade700);
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
