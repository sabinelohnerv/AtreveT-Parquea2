import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/garage_space_details_viewmodel.dart';
import 'package:parquea2/views/widgets/buttons/footer_buttons.dart';
import 'package:provider/provider.dart';
import 'widgets/vehicle/vehicle_information_group.dart';
import 'widgets/vehicle/vehicle_information_item.dart';

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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                    child: Center(
                      child: Container(
                        width: 400,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              child: Transform.rotate(
                                angle: 50 * 3.14159 / 180,
                                child: Column(
                                  children: [
                                    const RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(Icons.height)),
                                    Text('${garageSpace.measurements.width} M',
                                        style: const TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const RotatedBox(
                                      quarterTurns: 1,
                                      child: Icon(Icons.height)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${garageSpace.measurements.length} M',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 20,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Row(
                                  children: [
                                    const RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(Icons.height)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${garageSpace.measurements.height} M',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Provider.of<GarageSpaceDetailsViewModel>(context,
                          listen: false)
                      .determineState(garageSpace.state),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, right: 30.0, left: 30.0),
                    child: Column(
                      children: [
                        InformationGroup(
                          title: 'MEDIDAS',
                          items: [
                            InformationItem(
                              label: 'Alto:',
                              value:
                                  '${garageSpace.measurements.height} METROS',
                              leadingIcon: Icons.arrow_upward,
                            ),
                            InformationItem(
                              label: 'Ancho:',
                              value: '${garageSpace.measurements.width} METROS',
                              leadingIcon: Icons.width_full,
                            ),
                            InformationItem(
                              label: 'Largo:',
                              value:
                                  '${garageSpace.measurements.length} METROS',
                              leadingIcon: Icons.straighten,
                            ),
                          ],
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
                    iconData: Icons.change_circle,
                    label: 'CAMBIAR ESTADO',
                    onPressed: () {
                      Provider.of<GarageSpaceDetailsViewModel>(context,
                              listen: false)
                          .toggleGarageSpaceState(garageId, spaceId);
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Consumer<GarageSpaceDetailsViewModel>(
                    builder: (context, viewModel, child) {
                      return CustomFooterButton(
                        iconData: viewModel.isCloning
                            ? Icons.hourglass_top
                            : Icons.copy,
                        label: 'COPIAR ESPACIO',
                        onPressed: viewModel.isCloning
                            ? () {}
                            : () {
                                viewModel.cloneGarageSpace(
                                    context, garageId, garageSpace);
                              },
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: viewModel.isCloning
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : null,
                      );
                    },
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
