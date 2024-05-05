import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/viewmodels/provider/edit_garage_space_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';
import 'package:parquea2/views/widgets/textfields/custom_selectionfield.dart';
import 'package:provider/provider.dart';

class EditGarageSpaceView extends StatefulWidget {
  final String garageId;
  final GarageSpace garageSpace;

  const EditGarageSpaceView(
      {Key? key, required this.garageId, required this.garageSpace})
      : super(key: key);

  @override
  _EditGarageSpaceViewState createState() => _EditGarageSpaceViewState();
}

class _EditGarageSpaceViewState extends State<EditGarageSpaceView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditGarageSpaceViewModel>(
      create: (_) => EditGarageSpaceViewModel(
          widget.garageId, widget.garageSpace, GarageService()),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                "EDITAR ESPACIO",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
            ),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: Consumer<EditGarageSpaceViewModel>(
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
                        const SizedBox(height: 20),
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
                          labelText: 'Detalles',
                          controller: viewModel.detailsController,
                          onTap: () => viewModel.showDetailsDialog(context),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await viewModel.updateGarageSpace();
                            if (!viewModel.isUploading) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('ACTUALIZAR ESPACIO'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
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
