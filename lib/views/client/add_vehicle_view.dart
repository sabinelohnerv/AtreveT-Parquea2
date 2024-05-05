import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/viewmodels/client/add_vehicle_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_textfield.dart';
import 'package:parquea2/views/widgets/textfields/custom_numberinput.dart';

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  XFile? _image;

  @override
  Widget build(BuildContext context) {
    var vehicleViewModel = Provider.of<AddVehicleViewModel>(context);
    return Scaffold(
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
              vehicleViewModel.resetData();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "REGISTRAR VEHICULO",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
      ],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                            enabled: true,
                            controller: vehicleViewModel.makeController,
                            prefixIcon: const Icon(Icons.build_rounded),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextFormField(
                            labelText: 'Modelo',
                            enabled: true,
                            controller: vehicleViewModel.modelController,
                            prefixIcon: const Icon(Icons.directions_car_filled),
                          ),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                      labelText: 'Número de placa',
                      enabled: true,
                      controller: vehicleViewModel.plateController,
                      prefixIcon: const Icon(Icons.numbers_outlined),
                    ),
                    CustomNumberInput(
                      labelText: 'Año',
                      controller: vehicleViewModel.yearController,
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomNumberInput(
                            labelText: 'Alto',
                            controller: vehicleViewModel.heightController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomNumberInput(
                            labelText: 'Ancho',
                            controller: vehicleViewModel.widthController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomNumberInput(
                            labelText: 'Largo',
                            controller: vehicleViewModel.lengthController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _image == null
                        ? Container(
                            height: 220,
                            color: Colors.white,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : Image.file(
                            File(_image!.path),
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    TextButton.icon(
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image;
                            vehicleViewModel.imagePath = File(_image!.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Elegir Imagen'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });
                            _formKey.currentState!.save();
                            bool success = await vehicleViewModel
                                .addVehicle(ScaffoldMessenger.of(context));
                            if (success) {
                              Navigator.of(context).pop();
                            }
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        },
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white))
                            : const Text(
                                'REGISTRAR VEHICULO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
