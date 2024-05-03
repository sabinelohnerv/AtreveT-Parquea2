import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/viewmodels/edit_vehicle_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';
import 'package:provider/provider.dart';
import '/views/widgets/textfields/custom_textfield.dart';

class EditVehicleView extends StatefulWidget {
  final String userId;
  final Vehicle vehicle;

  const EditVehicleView({Key? key, required this.userId, required this.vehicle})
      : super(key: key);

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
          appBar: AppBar(
            title: const Text('EDITAR VEHÍCULO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: primaryColor,
          ),
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
                      CustomTextFormField(
                        labelText: 'Marca',
                        controller: viewModel.makeController,
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      CustomTextFormField(
                        labelText: 'Modelo',
                        controller: viewModel.modelController,
                        prefixIcon: Icon(Icons.model_training),
                      ),
                      CustomNumberInput(
                        labelText: 'Año',
                        controller: viewModel.yearController,
                        prefixIcon:
                            Icons.calendar_today,
                      ),
                      CustomTextFormField(
                        labelText: 'Número de placa',
                        controller: viewModel.plateController,
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomNumberInput(
                              labelText: 'Alto',
                              controller: viewModel.heightController,
                              prefixIcon: Icons.height,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomNumberInput(
                              labelText: 'Ancho',
                              controller: viewModel.widthController,
                              prefixIcon: Icons.square_foot,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomNumberInput(
                              labelText: 'Largo',
                              controller: viewModel.lengthController,
                              prefixIcon: Icons.straighten,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _image == null
                          ? Image.network(viewModel.imageUrl, height: 200)
                          : Image.file(File(_image!.path), height: 200),
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
                          bool updated = await viewModel.updateVehicle();
                          if (updated) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
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
    );
  }
}

class CustomNumberInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData? prefixIcon;

  const CustomNumberInput({
    Key? key,
    required this.labelText,
    required this.controller,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        ),
        controller: controller,
      ),
    );
  }
}
