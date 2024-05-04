import 'package:flutter/material.dart';
import 'package:parquea2/functions/util.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/viewmodels/client_garage_details_viewmodel.dart';
import 'package:parquea2/views/client_garage_spaces_list_view.dart';
import 'package:provider/provider.dart';

import '../services/whatsapp_service.dart';
import 'widgets/buttons/footer_buttons.dart';
import 'widgets/garages/garage_tile.dart';

class ClientGarageDetailsView extends StatelessWidget {
  final Garage garage;

  ClientGarageDetailsView({super.key, required this.garage});
  final WhatsAppService _whatsAppService = WhatsAppService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ClientGarageDetailsViewModel()..loadGarageAndProvider(garage.id),
      child: Consumer<ClientGarageDetailsViewModel>(
        builder: (context, viewModel, child) {
          var garage = viewModel.garage;
          if (garage == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                icon: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30)),
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              garage.imgUrl ?? 'path/to/default/image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          garage.name,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          garage.location.location,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InformationTile(
                                title: "Rating",
                                value: garage.rating.toString(),
                                icon: Icons.star),
                            InformationTile(
                                title: "Espacios",
                                value: garage.numberOfSpaces.toString(),
                                icon: Icons.garage),
                            InformationTile(
                                title: "Reservas",
                                value: garage.reservationsCompleted.toString(),
                                icon: Icons.group_rounded),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            InformationTile(
                              title: "Host",
                              value: viewModel.provider?.fullName ?? "Cargando",
                              icon: Icons.person_pin_rounded,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  WhatsAppService().sendMessage(
                                      viewModel.provider!.phoneNumber,
                                      'Estoy interesado en su espacio de garaje!');
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/wpp.png', // URL of your WhatsApp icon image
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Contactar'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Ubicacion',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            '${garage.location.coordinates}\n${garage.location.location}\n${garage.location.reference}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w100),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.details,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Detalles',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: garage.details!
                                  .map((detail) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Chip(label: Text(detail)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFooterButton(
                    iconData: Icons.calendar_today,
                    label: 'HORARIOS',
                    onPressed: () =>
                        _showAvailableTimes(context, garage.availableTime),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  CustomFooterButton(
                    iconData: Icons.space_dashboard_sharp,
                    label: 'VER ESPACIOS',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientGarageSpacesListView(
                          garage: garage,
                        ),
                      ),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAvailableTimes(
      BuildContext context, List<AvailableTimeInDay> availableTimes) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: availableTimes.length,
            itemBuilder: (context, index) {
              var dayTime = availableTimes[index];
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(translateDay(dayTime.day)),
                  children: dayTime.availableTime
                          ?.map((time) => ListTile(
                                title:
                                    Text('${time.startTime} - ${time.endTime}'),
                              ))
                          .toList() ??
                      [const ListTile(title: Text('Sin horarios disponibles'))],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
