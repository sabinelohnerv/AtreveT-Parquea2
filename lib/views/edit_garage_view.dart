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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Foto del Garaje',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image;
                            });
                            // Update the image path in the view model
                            garageViewModel.imagePath = File(_image!.path);
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Elegir Imagen'),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      child: Text(
                        'Detalles de Dirección',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ...List.generate(garageViewModel.availableTime.length,
                        (index) {
                      return dayAvailabilityWidget(
                          garageViewModel.availableTime[index].day,
                          garageViewModel.availableTime[index].availableTime!,
                          context,
                          garageViewModel);
                    }),
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

  void showEditDialog(BuildContext context, String day,
      List<AvailableTime> times, EditGarageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Utiliza StatefulBuilder para manejar el estado local
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Editar horarios para $day'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: times.map((time) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${time.startTime} - ${time.endTime}'),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            TimeOfDay? newStartTime = await showTimePicker(
                              context: context,
                              initialTime: timeOfDayFromString(time.startTime),
                            );
                            TimeOfDay? newEndTime = await showTimePicker(
                              context: context,
                              initialTime: timeOfDayFromString(time.endTime),
                            );
                            if (newStartTime != null && newEndTime != null) {
                              AvailableTime updatedTime = AvailableTime(
                                startTime: formatTimeOfDay(newStartTime),
                                endTime: formatTimeOfDay(newEndTime),
                              );
                              int timeIndex = times.indexOf(time);
                              times[timeIndex] = updatedTime;
                              viewModel.updateDayAvailability(day, times);
                              setState(
                                  () {}); // Llama a setState para actualizar la UI del diálogo
                            }
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  TimeOfDay timeOfDayFromString(String timeStr) {
    List<String> parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void showAddTimeDialog(
      BuildContext context, String day, EditGarageViewModel viewModel) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir nuevo horario para $day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                    'Hora de inicio: ${startTime?.format(context) ?? 'Seleccione'}'),
                onTap: () async {
                  final TimeOfDay? pickedStartTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedStartTime != null) {
                    startTime = pickedStartTime;
                    // Forcing rebuild of AlertDialog by setting state
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
              ListTile(
                title: Text(
                    'Hora de fin: ${endTime?.format(context) ?? 'Seleccione'}'),
                onTap: () async {
                  final TimeOfDay? pickedEndTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now()
                        .replacing(hour: TimeOfDay.now().hour + 1),
                  );
                  if (pickedEndTime != null) {
                    endTime = pickedEndTime;
                    // Forcing rebuild of AlertDialog by setting state
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar')),
            TextButton(
                onPressed: () {
                  if (startTime != null && endTime != null) {
                    AvailableTime newTime = AvailableTime(
                        startTime:
                            '${startTime?.hour}:${startTime?.minute.toString().padLeft(2, '0')}',
                        endTime:
                            '${endTime?.hour}:${endTime?.minute.toString().padLeft(2, '0')}');
                    viewModel.addAvailableTime(day, newTime);
                    Navigator.of(context).pop();
                  } else {
                    // Optionally alert the user that both times need to be selected
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Por favor seleccione ambas horas de inicio y fin."),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Text('Añadir')),
          ],
        );
      },
    );
  }

  Widget dayAvailabilityWidget(String day, List<AvailableTime> times,
      BuildContext context, EditGarageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showEditDialog(context, day, times, viewModel),
              )
            ],
          ),
        ),
        ...times.map((time) {
          return ListTile(
            title: Text('${time.startTime} - ${time.endTime}'),
          );
        }).toList(),
      ],
    );
  }
}
