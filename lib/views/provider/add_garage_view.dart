import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/viewmodels/provider/edit_garage_viewmodel.dart';
import 'package:parquea2/viewmodels/provider/provider_add_garage_viewmodel.dart';
import 'package:parquea2/views/widgets/textfields/custom_selectionfield.dart';
import 'package:parquea2/views/widgets/textfields/custom_textfield.dart';
import 'package:provider/provider.dart';

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

  String getDayInSpanish(String englishDayName) {
  // Mapping of English day names to Spanish day names
  Map<String, String> dayNameMap = {
    'Monday': 'Lunes',
    'Tuesday': 'Martes',
    'Wednesday': 'Miércoles',
    'Thursday': 'Jueves',
    'Friday': 'Viernes',
    'Saturday': 'Sábado',
    'Sunday': 'Domingo',
  };

  // Return the Spanish day name corresponding to the given English day name
  return dayNameMap[englishDayName] ?? 'Día desconocido';
}

  @override
  Widget build(BuildContext context) {
    var garageViewModel = Provider.of<AddGarageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "REGISTRAR GARAJE",
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
                  enabled: true,
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
                  enabled: true,
                  controller: garageViewModel.locationController,
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
                  enabled: false,
                  controller: garageViewModel.coordinatesController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la ubicación del garaje.';
                    }
                    return null;
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    garageViewModel.selectLocation(context);
                  },
                ),
                CustomTextFormField(
                  labelText: 'Indicaciones Adicionales',
                  enabled: true,
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
                        garageViewModel.resetData();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('REGISTRAR GARAJE'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dayAvailabilityWidget(String englishDayName, List<AvailableTime> times, BuildContext context, EditGarageViewModel viewModel) {
  String dayInSpanish = getDayInSpanish(englishDayName);  // Get the Spanish name for the day

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dayInSpanish, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => viewModel.showAddTimeDialog(context, englishDayName),
            ),
          ],
        ),
      ),
      ...times.map((AvailableTime time) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            title: Text('${time.startTime} - ${time.endTime}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => viewModel.showEditTimeDialog(context, englishDayName, time),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => viewModel.removeTime(englishDayName, time),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ],
  );
}
}
