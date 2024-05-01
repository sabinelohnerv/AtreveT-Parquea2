import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/viewmodels/add_garage_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_selectionfield.dart';
import 'package:parquea2/views/widgets/textfields/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:parquea2/models/location.dart';

class AddGarageView extends StatefulWidget {
  const AddGarageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddGarageViewState();
  }
}

class _AddGarageViewState extends State<AddGarageView> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    var garageViewModel = Provider.of<AddGarageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agregar Garaje",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
                  onSaved: (value) => garageViewModel.name = value!,
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
                          width: MediaQuery.sizeOf(context).width,
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
                  onSaved: (value) => garageViewModel.location =
                      Location(location: value!, coordinates: ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección del garaje.';
                    }
                    return null;
                  },
                ),
                //TODO: Implement Location Coordenates From Google Maps API
                CustomTextFormField(
                  labelText: 'Ubicación',
                  onSaved: (value) => garageViewModel.coordinates = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la ubicación del garaje.';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  labelText: 'Indicaciones Adicionales',
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      garageViewModel.coordinates = value;
                    } else {
                      garageViewModel.coordinates = '';
                    }
                  },
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
                dayAvailabilityWidget('Lunes', 'monday',
                    garageViewModel.monday.availableTime!, context),
                dayAvailabilityWidget('Martes', 'tuesday',
                    garageViewModel.tuesday.availableTime!, context),
                dayAvailabilityWidget('Miércoles', 'wednesday',
                    garageViewModel.wednesday.availableTime!, context),
                dayAvailabilityWidget('Jueves', 'thursday',
                    garageViewModel.thursday.availableTime!, context),
                dayAvailabilityWidget('Viernes', 'friday',
                    garageViewModel.friday.availableTime!, context),
                dayAvailabilityWidget('Sábado', 'saturday',
                    garageViewModel.saturday.availableTime!, context),
                dayAvailabilityWidget('Domingo', 'sunday',
                    garageViewModel.sunday.availableTime!, context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await garageViewModel.addGarage();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Garaje agregado exitosamente'),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Agregar Garaje'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dayAvailabilityWidget(String dayName, String day,
      List<AvailableTime> times, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () =>
                    Provider.of<AddGarageViewModel>(context, listen: false)
                        .showTimePickerDialog(context, day),
              )
            ],
          ),
        ),
        Consumer<AddGarageViewModel>(
          builder: (_, vm, __) => Column(
            children: vm.findDay(day)?.availableTime?.map((time) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        title: Text('${time.startTime} - ${time.endTime}',
                            style: const TextStyle(fontSize: 16)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () =>
                                  vm.showEditTimeDialog(context, day, time),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => vm.removeTime(day, time),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ),
        if (times.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text('No hay tiempos seleccionados',
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
      ],
    );
  }
}
