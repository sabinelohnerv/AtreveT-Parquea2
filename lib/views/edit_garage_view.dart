import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/viewmodels/edit_garage_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_selectionfield.dart';
import 'package:parquea2/views/widgets/textfields/custom_textfield.dart';
import 'package:provider/provider.dart';

class EditGarageView extends StatefulWidget {
  final Garage garage;

  const EditGarageView({Key? key, required this.garage}) : super(key: key);

  @override
  _EditGarageViewState createState() => _EditGarageViewState();
}

class _EditGarageViewState extends State<EditGarageView> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditGarageViewModel(widget.garage),
      child: Consumer<EditGarageViewModel>(
        builder: (context, garageViewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Editar Garaje"),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      labelText: 'Nombre del Garaje',
                      controller: garageViewModel.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del garaje.';
                        }
                        return null;
                      },
                    ),
                    CustomSelectionField(
                      labelText: 'Detalles del Garaje',
                      controller: garageViewModel.detailsController,
                      onTap: () => garageViewModel.showDetailsDialog(context),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Foto del Garaje',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    _image == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                                height: 220,
                                color: Colors.grey.shade100,
                                child: const Center(
                                    child: Text(
                                        'No has seleccionado una imagen aún.'))),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              child: Image.file(
                                File(
                                  _image!.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextButton.icon(
                        onPressed: () async {
                          final XFile? image =
                              await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image;
                              garageViewModel.imagePath = File(_image!.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Elegir Imagen'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Detalles de Dirección',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    CustomTextFormField(
                      labelText: 'Dirección Escrita',
                      controller: garageViewModel.locationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la dirección del garaje.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Ubicación',
                      controller: garageViewModel.coordinatesController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la ubicación del garaje.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      labelText: 'Indicaciones Adicionales',
                      controller: garageViewModel.referenceController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Text(
                        'Disponibilidad Semanal',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Repeat this for each day as in the add garage screen
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await garageViewModel.updateGarage();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Garaje actualizado exitosamente'),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Actualizar Garaje'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
