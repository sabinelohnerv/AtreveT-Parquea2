import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/add_garage_space_viewmodel.dart';
import 'package:parquea2/viewmodels/add_vehicle_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';
import 'package:parquea2/views/widgets/textfields/custom_selectionfield.dart';

import 'package:provider/provider.dart';

class AddGarageSpaceView extends StatefulWidget {
  final String garageId;

  const AddGarageSpaceView({super.key, required this.garageId});

  @override
  State<AddGarageSpaceView> createState() => _AddGarageSpaceViewState();
}

class _AddGarageSpaceViewState extends State<AddGarageSpaceView> {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<AddGarageSpaceViewModel>(context);
    return ChangeNotifierProvider<AddGarageSpaceViewModel>(
      create: (_) => AddGarageSpaceViewModel(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxisScrolled) => [
            SliverAppBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  viewModel.resetData();
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                "REGISTRAR ESPACIO",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
            ),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: Consumer<AddGarageSpaceViewModel>(
              builder: (context, viewModel, _) => Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: Text(
                            'Dimensiones del Espacio',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        CustomNumberInput(
                          labelText: 'Ancho (m)',
                          controller: viewModel.widthController,
                        ),
                        CustomNumberInput(
                          labelText: 'Altura (m)',
                          controller: viewModel.heightController,
                        ),
                        CustomNumberInput(
                          labelText: 'Longitud (m)',
                          controller: viewModel.lengthController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: Text(
                            'Detalles Adicionales',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        CustomSelectionField(
                          labelText: 'Detalles del Garaje',
                          controller: viewModel.detailsController,
                          onTap: () => viewModel.showDetailsDialog(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: FilledButton(
                            onPressed: () async {
                              await viewModel.addGarageSpace(widget.garageId);
                              viewModel.resetData();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('REGISTRAR ESPACIO'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
