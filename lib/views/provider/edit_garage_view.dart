import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/functions/util.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/viewmodels/provider/edit_garage_viewmodel.dart';
import 'package:parquea2/views/select_location_view.dart';
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
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.garage.imgUrl;
  }

  String formatDayOfWeek(String day) {
    var now = DateTime.now();
    int daysToAdd = (DateFormat.E('en_US').dateSymbols.FIRSTDAYOFWEEK -
            now.weekday +
            DateFormat.E('en_US')
                .dateSymbols
                .STANDALONENARROWWEEKDAYS
                .indexOf(day)) %
        7;
    var date = now.add(Duration(days: daysToAdd));
    return DateFormat('EEEE', 'es_ES').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditGarageViewModel(widget.garage),
      child: Consumer<EditGarageViewModel>(
        builder: (context, garageViewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text(
              "EDITAR GARAJE",
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
                            child: _imageUrl == null
                                ? Container(
                                    height: 220,
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                        child: Text(
                                            'No has seleccionado una imagen aún.')),
                                  )
                                : SizedBox(
                                    height: 220,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(_imageUrl!,
                                        fit: BoxFit.cover),
                                  ),
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
                            String newImageUrl = await garageViewModel
                                .uploadImageToFirebase(File(_image!.path));
                            setState(() {
                              _imageUrl = newImageUrl;
                            });
                            garageViewModel.updateImageUrl(newImageUrl);
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
                      enabled: true,
                      controller: garageViewModel.locationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la dirección del garaje.';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        LatLng? newLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectLocationView(),
                          ),
                        );
                        if (newLocation != null) {
                          garageViewModel.coordinatesController.text =
                              '${newLocation.latitude}, ${newLocation.longitude}';
                        }
                      },
                      child: CustomTextFormField(
                        labelText: 'Ubicación',
                        onTap: () async {
                          LatLng? newLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectLocationView(),
                            ),
                          );
                          if (newLocation != null) {
                            garageViewModel.coordinatesController.text =
                                '${newLocation.latitude}, ${newLocation.longitude}';
                          }
                        },
                        controller: garageViewModel.coordinatesController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la ubicación del garaje.';
                          }
                          return null;
                        },
                      ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ...List.generate(garageViewModel.availableTime.length,
                        (index) {
                      return dayAvailabilityWidget(
                          garageViewModel.availableTime[index].day,
                          garageViewModel.availableTime[index].availableTime!
                              as List<AvailableTime>,
                          context as BuildContext,
                          garageViewModel as EditGarageViewModel);
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
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('ACTUALIZAR GARAJE'),
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

  void showAddTimeDialog(BuildContext context, String day) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        TimeOfDay? startTime;
        TimeOfDay? endTime;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Agregar nuevo rango de disponibilidad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(startTime == null
                        ? 'Selecciona la Hora de Inicio'
                        : 'Hora de Inicio: ${formatTimeOfDay(startTime!)}'),
                    onTap: () async {
                      TimeOfDay? pickedStartTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedStartTime != null) {
                        setState(() {
                          startTime = pickedStartTime;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(endTime == null
                        ? 'Selecciona la Hora de Fin'
                        : 'Hora de Fin: ${formatTimeOfDay(endTime!)}'),
                    onTap: () async {
                      TimeOfDay? pickedEndTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1),
                      );
                      if (pickedEndTime != null) {
                        setState(() {
                          endTime = pickedEndTime;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (startTime != null && endTime != null) {
                        AvailableTime newTime = AvailableTime(
                          startTime: formatTimeOfDay(startTime!),
                          endTime: formatTimeOfDay(endTime!),
                        );
                        Provider.of<EditGarageViewModel>(context, listen: false).addAvailableTime(day, newTime);
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar Todo el Día'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


  TimeOfDay timeOfDayFromString(String timeStr) {
    List<String> parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

 void showAddTimeDialog(BuildContext context, String day) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        TimeOfDay? startTime;
        TimeOfDay? endTime;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Agregar nuevo rango de disponibilidad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(startTime == null
                        ? 'Selecciona la Hora de Inicio'
                        : 'Hora de Inicio: ${formatTimeOfDay(startTime!)}'),
                    onTap: () async {
                      TimeOfDay? pickedStartTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedStartTime != null) {
                        setState(() {
                          startTime = pickedStartTime;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(endTime == null
                        ? 'Selecciona la Hora de Fin'
                        : 'Hora de Fin: ${formatTimeOfDay(endTime!)}'),
                    onTap: () async {
                      TimeOfDay? pickedEndTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1),
                      );
                      if (pickedEndTime != null) {
                        setState(() {
                          endTime = pickedEndTime;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (startTime != null && endTime != null) {
                        AvailableTime newTime = AvailableTime(
                          startTime: formatTimeOfDay(startTime!),
                          endTime: formatTimeOfDay(endTime!),
                        );
                        Provider.of<EditGarageViewModel>(context, listen: false).addAvailableTime(day, newTime);
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar Todo el Día'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Widget dayAvailabilityWidget(String englishDayName, List<AvailableTime> times, BuildContext context, EditGarageViewModel viewModel) {
  String dayInSpanish = translateDay(englishDayName.toLowerCase()); // Utiliza la función utilitaria para traducir el día.

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
      if (times.isEmpty)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text('No hay tiempos seleccionados', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
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