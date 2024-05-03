import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/viewmodels/edit_vehicle_viewmodel.dart';
import 'package:provider/provider.dart';
import '/views/widgets/textfields/custom_textfield.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';

class EditVehicleView extends StatefulWidget {
  final String userId;
  final Vehicle vehicle;

  const EditVehicleView(
      {super.key, required this.userId, required this.vehicle});

  @override
  _EditVehicleViewState createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends State<EditVehicleView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return ChangeNotifierProvider<EditVehicleViewModel>(
      create: (_) =>
          EditVehicleViewModel(widget.userId, widget.vehicle, VehicleService()),
      child: Consumer<EditVehicleViewModel>(
        builder: (context, viewModel, _) => Scaffold(
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
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: const Text(
                  "EDITAR VEHICULO",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                centerTitle: true,
              ),
            ],
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Marca',
                                controller: viewModel.makeController,
                                prefixIcon: const Icon(Icons.directions_car),
                              ),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Modelo',
                                controller: viewModel.modelController,
                                prefixIcon: const Icon(Icons.model_training),
                              ),
                            ),
                          ],
                        ),
                        CustomNumberInput(
                          labelText: 'Año',
                          controller: viewModel.yearController,
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        CustomTextFormField(
                          labelText: 'Número de placa',
                          controller: viewModel.plateController,
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomNumberInput(
                                labelText: 'Alto',
                                controller: viewModel.heightController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomNumberInput(
                                labelText: 'Ancho',
                                controller: viewModel.widthController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomNumberInput(
                                labelText: 'Largo',
                                controller: viewModel.lengthController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _image == null
                            ? (viewModel.imageUrl.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: SizedBox(
                                        height: 220,
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Image.network(
                                          viewModel.imageUrl,
                                          fit: BoxFit.cover,
                                        )),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Container(
                                      height: 220,
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ))
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                    height: 220,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                        TextButton.icon(
                          onPressed: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              setState(() => _image = image);
                              await viewModel.uploadImage(File(image.path));
                            }
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cambiar Imagen'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            File fileImage = File('');
                            if (_image != null) {
                              fileImage = File(_image!.path);
                            }
                            bool updated =
                                await viewModel.updateVehicle(fileImage);
                            if (updated) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Vehículo actualizado correctamente.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('ACTUALIZAR VEHÍCULO'),
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
