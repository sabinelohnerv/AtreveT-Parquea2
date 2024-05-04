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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'OFERTA',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${offer.payOffer.toString()}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 40,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            child: const Text(
                              'CONTRAOFERTA',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    InformationGroup(
                      title: 'CLIENTE',
                      items: [
                        InformationItem(
                          label: 'Nombre:',
                          value: offer.client.fullName.toUpperCase(),
                          leadingIcon: Icons.person,
                        ),
                        InformationItem(
                          label: 'Rating:',
                          value: offer.client.rating.toString(),
                          leadingIcon: Icons.star,
                        ),
                        InformationItem(
                          label: 'Placa:',
                          value: offer.vehicle.plateNumber.toUpperCase(),
                          leadingIcon: Icons.numbers,
                        ),
                      ],
                    ),
                    InformationGroup(
                      title: 'TIEMPO',
                      items: [
                        InformationItem(
                          label: 'Comienzo:',
                          value: offer.time.startTime,
                          leadingIcon: Icons.access_time,
                        ),
                        InformationItem(
                          label: 'Fin:',
                          value: offer.time.endTime,
                          leadingIcon: Icons.hourglass_bottom,
                        ),
                        InformationItem(
                          label: 'Fecha:',
                          value: offer.date,
                          leadingIcon: Icons.calendar_month,
                        ),
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
                    iconData: Icons.check_sharp,
                    label: 'ACEPTAR',
                    onPressed: () {
                      //TODO: Implement creating the reservation document
                      viewModel.updateOfferState(
                        offerId,
                        'accepted',
                      );
                      Navigator.of(context).pop();
                    },
                    color: Colors.green,
                  ),
                  CustomFooterButton(
                    iconData: Icons.close_sharp,
                    label: 'RECHAZAR',
                    onPressed: () {
                      viewModel.updateOfferState(
                        offerId,
                        'rejected-by-provider',
                      );
                      Navigator.of(context).pop();
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
