import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/location.dart';
import 'package:parquea2/services/garage_service.dart';

class AddGarageViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();

  AddGarageViewModel();

  bool _isUploading = false;

  String? _imgUrl = '';
  String _name = '';
  Location _location = Location(location: '', coordinates: '');
  String _coordinates = '';
  String? _reference;
  List<String>? _details;
  List<AvailableTimeInDay> _availableTime = [];
  AvailableTimeInDay monday =
      AvailableTimeInDay(day: 'monday', availableTime: []);
  AvailableTimeInDay tuesday =
      AvailableTimeInDay(day: 'tuesday', availableTime: []);
  AvailableTimeInDay wednesday =
      AvailableTimeInDay(day: 'wednesday', availableTime: []);
  AvailableTimeInDay thursday =
      AvailableTimeInDay(day: 'thursday', availableTime: []);
  AvailableTimeInDay friday =
      AvailableTimeInDay(day: 'friday', availableTime: []);
  AvailableTimeInDay saturday =
      AvailableTimeInDay(day: 'saturday', availableTime: []);
  AvailableTimeInDay sunday =
      AvailableTimeInDay(day: 'sunday', availableTime: []);
  int _numberOfSpaces = 0;
  int _reservationsCompleted = 0;
  double _rating = 0.0;
  File? imagePath;

  //Getters
  bool get isUploading => _isUploading;

  String get name => _name;
  Location get location => _location;
  String get coordinates => _coordinates;
  String? get reference => _reference;
  List<String>? get details => _details;
  List<AvailableTimeInDay> get availableTime => _availableTime;
  int get numberOfSpaces => _numberOfSpaces;
  int get reservationsCompleted => _reservationsCompleted;
  double get rating => _rating;

  List<String> predefinedDetails = [
    'Portón con visibilidad hacia afuera',
    'Portón sin visibilidad hacia afuera',
    'Cámaras internas',
    'Cámaras al ingreso',
    'Vigilancia por guardias',
  ];

  List<String> selectedDetails = [];
  TextEditingController detailsController = TextEditingController();

  //Setters
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set location(Location value) {
    _location = value;
    notifyListeners();
  }

  set coordinates(String value) {
    _coordinates = value;
    notifyListeners();
  }

  set reference(String? value) {
    _reference = value;
    notifyListeners();
  }

  set details(List<String>? value) {
    _details = value;
    notifyListeners();
  }

  set availableTime(List<AvailableTimeInDay> value) {
    _availableTime = value;
    notifyListeners();
  }

  set numberOfSpaces(int value) {
    _numberOfSpaces = value;
    notifyListeners();
  }

  set reservationsCompleted(int value) {
    _reservationsCompleted = value;
    notifyListeners();
  }

  set rating(double value) {
    _rating = value;
    notifyListeners();
  }

  //Details
  void showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detalles del Parqueo',
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: predefinedDetails.map((detail) {
                    return CheckboxListTile(
                      title: Text(detail),
                      value: selectedDetails.contains(detail),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true &&
                              !selectedDetails.contains(detail)) {
                            selectedDetails.add(detail);
                          } else if (value == false) {
                            selectedDetails.remove(detail);
                          }
                        });
                        updateDetails(selectedDetails);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDetails(List<String> newDetails) {
    selectedDetails = newDetails;
    detailsController.text = selectedDetails.join(', ');
    notifyListeners();
  }

  //Select Available Time

  Future<void> showTimePickerDialog(BuildContext context, String day) async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Agregar nuevo rango de disponibilidad',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Selecciona un Horario',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListTile(
                  title: Text(startTime == null
                      ? 'Selecciona la Hora de Inicio'
                      : 'Hora de Inicio: ${formatTimeOfDay(startTime!)}'),
                  onTap: () async {
                    TimeOfDay? pickedStartTime = await showTimePicker(
                      context: dialogContext,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedStartTime != null) {
                      startTime = pickedStartTime;
                      (dialogContext as Element).markNeedsBuild();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListTile(
                  title: Text(endTime == null
                      ? 'Selecciona la Hora de Fin'
                      : 'Hora de Fin: ${formatTimeOfDay(endTime!)}'),
                  onTap: () async {
                    TimeOfDay? pickedEndTime = await showTimePicker(
                      context: dialogContext,
                      initialTime: TimeOfDay.now()
                          .replacing(hour: TimeOfDay.now().hour + 1),
                    );
                    if (pickedEndTime != null) {
                      endTime = pickedEndTime;
                      (dialogContext as Element).markNeedsBuild();
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'O',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  AvailableTime newTime = AvailableTime(
                    startTime: '00:00',
                    endTime: '23:59',
                  );
                  setStateForDay(day, newTime, true);
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Disponible Todo El Día',
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (startTime != null && endTime != null) {
                      AvailableTime newTime = AvailableTime(
                        startTime: formatTimeOfDay(startTime!),
                        endTime: formatTimeOfDay(endTime!),
                      );
                      setStateForDay(day, newTime, false);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditTimeDialog(
      BuildContext context, String day, AvailableTime time) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Editar Horario',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    title: Text('Hora de Inicio: ${time.startTime}'),
                    onTap: () async {
                      TimeOfDay? newStartTime = await showTimePicker(
                          context: context,
                          initialTime: timeOfDayFromString(time.startTime));
                      if (newStartTime != null) {
                        time.startTime = formatTimeOfDay(newStartTime);
                        notifyListeners();
                        (dialogContext as Element).markNeedsBuild();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    title: Text('Hora de Fin: ${time.endTime}'),
                    onTap: () async {
                      TimeOfDay? newEndTime = await showTimePicker(
                          context: context,
                          initialTime: timeOfDayFromString(time.endTime));
                      if (newEndTime != null) {
                        time.endTime = formatTimeOfDay(newEndTime);
                        notifyListeners();
                        (dialogContext as Element).markNeedsBuild();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    editTime(day, time, timeOfDayFromString(time.startTime),
                        timeOfDayFromString(time.endTime));
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  TimeOfDay timeOfDayFromString(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void setStateForDay(String day, AvailableTime time, bool needsClear) {
    var dayToUpdate = findDay(day);
    if (dayToUpdate != null) {
      if (needsClear) {
        dayToUpdate.availableTime!.clear();
      }
      dayToUpdate.availableTime!.add(time);
      notifyListeners();
    }
  }

  AvailableTimeInDay? findDay(String day) {
    List<AvailableTimeInDay> days = [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday
    ];
    for (AvailableTimeInDay dayEntry in days) {
      if (dayEntry.day == day.toLowerCase()) {
        return dayEntry;
      }
    }
    return null;
  }

  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void removeTime(String day, AvailableTime time) {
    AvailableTimeInDay? dayToUpdate = findDay(day);
    if (dayToUpdate != null && dayToUpdate.availableTime != null) {
      dayToUpdate.availableTime!.remove(time);
      notifyListeners();
    }
  }

  void editTime(String day, AvailableTime oldTime, TimeOfDay newStartTime,
      TimeOfDay newEndTime) {
    AvailableTimeInDay? dayToUpdate = findDay(day);
    if (dayToUpdate != null && dayToUpdate.availableTime != null) {
      int index = dayToUpdate.availableTime!.indexOf(oldTime);
      if (index != -1) {
        dayToUpdate.availableTime![index] = AvailableTime(
            startTime: formatTimeOfDay(newStartTime),
            endTime: formatTimeOfDay(newEndTime));
        notifyListeners();
      }
    }
  }

  //Save Garage
  Future<void> uploadGarageImage(String garageId) async {
    if (imagePath != null) {
      _imgUrl = await _garageService.uploadGarageImage(imagePath!, garageId);
      notifyListeners();
    }
  }

  void addTimesToAvailableTime() {
    _availableTime.add(monday);
    _availableTime.add(tuesday);
    _availableTime.add(wednesday);
    _availableTime.add(thursday);
    _availableTime.add(friday);
    _availableTime.add(saturday);
    _availableTime.add(sunday);
    notifyListeners();
  }

  Future<void> addGarage() async {
    _isUploading = true;
    notifyListeners();
    _location = Location(
        location: _location.location,
        coordinates: _coordinates,
        reference: _reference);
    String garageId = "Garage_${DateTime.now().millisecondsSinceEpoch}";
    addTimesToAvailableTime();
    uploadGarageImage(garageId);
    Garage newGarage = Garage(
      id: garageId,
      userId: _garageService.userId,
      name: _name,
      imgUrl: _imgUrl,
      location: _location,
      details: _details,
      availableTime: _availableTime,
      numberOfSpaces: _numberOfSpaces,
      reservationsCompleted: _reservationsCompleted,
      rating: _rating,
    );

    await _garageService.addGarage(newGarage);
  }
}
