import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/location.dart';
import 'package:parquea2/services/garage_service.dart';

class EditGarageViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  final Garage _originalGarage;
  bool _isUploading = false;

  TextEditingController nameController;
  TextEditingController locationController;
  TextEditingController coordinatesController;
  TextEditingController referenceController;
  TextEditingController detailsController;
  File? imagePath;
  String? imageUrl;

  EditGarageViewModel(this._originalGarage)
      : nameController = TextEditingController(text: _originalGarage.name),
        locationController =
            TextEditingController(text: _originalGarage.location.location),
        coordinatesController =
            TextEditingController(text: _originalGarage.location.coordinates),
        referenceController =
            TextEditingController(text: _originalGarage.location.reference),
        detailsController =
            TextEditingController(text: _originalGarage.details?.join(', ')),
        imageUrl = _originalGarage.imgUrl;

  List<AvailableTimeInDay> get availableTime => _originalGarage.availableTime;

  void updateImageUrl(String newUrl) async {
    imageUrl = newUrl;
    notifyListeners();

    _originalGarage.imgUrl = newUrl;

    try {
      await _garageService.updateGarageImageUrl(_originalGarage.id, newUrl);
    } catch (e) {
      print("Error updating image URL in Firestore: $e");
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName =
          'garage_images/${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> updateGarage() async {
    _isUploading = true;
    notifyListeners();

    Location updatedLocation = Location(
      location: locationController.text,
      coordinates: coordinatesController.text,
      reference: referenceController.text,
    );

    List<String>? details = detailsController.text.isNotEmpty
        ? detailsController.text.split(', ').map((s) => s.trim()).toList()
        : null;

    Garage updatedGarage = Garage(
      id: _originalGarage.id,
      userId: _originalGarage.userId,
      name: nameController.text,
      imgUrl: _originalGarage.imgUrl,
      location: updatedLocation,
      details: details,
      availableTime: _originalGarage.availableTime,
      numberOfSpaces: _originalGarage.numberOfSpaces,
      reservationsCompleted: _originalGarage.reservationsCompleted,
      ratingsCompleted: _originalGarage.ratingsCompleted,
      rating: _originalGarage.rating,
    );

    await _garageService.updateGarage(updatedGarage);
    _isUploading = false;
    notifyListeners();
  }

  void updateDayAvailability(String day, List<AvailableTime> newTimes) {
    int index = _originalGarage.availableTime.indexWhere((d) => d.day == day);
    if (index != -1) {
      _originalGarage.availableTime[index].availableTime = newTimes;
      notifyListeners();
    }
  }

  void addAvailableTime(String day, AvailableTime time) {
    int index = _originalGarage.availableTime.indexWhere((d) => d.day == day);
    if (index != -1) {
      _originalGarage.availableTime[index].availableTime ??= [];
      _originalGarage.availableTime[index].availableTime!.add(time);
      notifyListeners();
    }
  }

  void removeTime(String day, AvailableTime time) {
    int index = _originalGarage.availableTime.indexWhere((d) => d.day == day);
    if (index != -1) {
      _originalGarage.availableTime[index].availableTime?.remove(time);
      notifyListeners();
    }
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (startTime != null && endTime != null) {
                    AvailableTime newTime = AvailableTime(
                      startTime: formatTimeOfDay(startTime!),
                      endTime: formatTimeOfDay(endTime!),
                    );
                    addAvailableTime(day, newTime);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showEditTimeDialog(BuildContext context, String day, AvailableTime time) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      TimeOfDay initialStartTime = timeOfDayFromString(time.startTime);
      TimeOfDay initialEndTime = timeOfDayFromString(time.endTime);

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Editar horario para $day'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Hora de inicio: ${formatTimeOfDay(initialStartTime)}'),
                  onTap: () async {
                    TimeOfDay? newStartTime = await showTimePicker(
                      context: context,
                      initialTime: initialStartTime,
                    );
                    if (newStartTime != null) {
                      setState(() {
                        time.startTime = formatTimeOfDay(newStartTime);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text('Hora de fin: ${formatTimeOfDay(initialEndTime)}'),
                  onTap: () async {
                    TimeOfDay? newEndTime = await showTimePicker(
                      context: context,
                      initialTime: initialEndTime,
                    );
                    if (newEndTime != null) {
                      setState(() {
                        time.endTime = formatTimeOfDay(newEndTime);
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  updateDayAvailability(day, _originalGarage.availableTime.firstWhere((x) => x.day == day).availableTime!);
                  notifyListeners();
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Garaje'),
          content:
              Text('Aquí puedes agregar detalles adicionales sobre tu garaje.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
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

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    coordinatesController.dispose();
    referenceController.dispose();
    detailsController.dispose();
    super.dispose();
  }
}
