import 'package:flutter/material.dart';
import 'package:parquea2/viewmodels/add_garage_space_viewmodel.dart';
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
    return ChangeNotifierProvider<AddGarageSpaceViewModel>(
      create: (_) => AddGarageSpaceViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Espacio de Garaje'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AddGarageSpaceViewModel>(
            builder: (context, viewModel, _) => Column(
              children: <Widget>[
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
                CustomSelectionField(
                  labelText: 'Detalles del Garaje',
                  controller: viewModel.detailsController,
                  onTap: () => viewModel.showDetailsDialog(context),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.addGarageSpace(widget.garageId);
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar Espacio'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
