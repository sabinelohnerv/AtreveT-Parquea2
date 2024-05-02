import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/location.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  EditGarageViewModel(this._originalGarage)
      : nameController = TextEditingController(text: _originalGarage.name),
        locationController = TextEditingController(text: _originalGarage.location.location),
        coordinatesController = TextEditingController(text: _originalGarage.location.coordinates),
        referenceController = TextEditingController(text: _originalGarage.location.reference),
        detailsController = TextEditingController(text: _originalGarage.details?.join(', '));

  List<AvailableTimeInDay> get availableTime => _originalGarage.availableTime;

  Future<void> updateGarage() async {
    _isUploading = true;
    notifyListeners();

    Location updatedLocation = Location(
      location: locationController.text,
      coordinates: coordinatesController.text,
      reference: referenceController.text,
    );

    List<String>? details = detailsController.text.isNotEmpty
        ? detailsController.text.split(',').map((s) => s.trim()).toList()
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
      rating: _originalGarage.rating,
    );

    await _garageService.updateGarage(updatedGarage);
    _isUploading = false;
    notifyListeners();
  }

  void updateDayAvailability(String day, List<AvailableTime> newTimes) {
    int index = _originalGarage.availableTime.indexWhere((d) => d.day == day);
    if (index != -1) {
      _originalGarage.availableTime[index].availableTime = newTimes ?? [];
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

  void showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Detalles'),
          content: TextField(
            controller: detailsController,
            decoration: const InputDecoration(hintText: "Detalles separados por comas"),
          ),
          actions: [
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
