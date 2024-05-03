import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parquea2/models/measurements.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:image_picker/image_picker.dart';

class EditVehicleViewModel extends ChangeNotifier {
  final VehicleService _vehicleService;
  final String userId;
  final Vehicle vehicle;

  bool _isUploading = false;
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  String? _imageUrl;

  EditVehicleViewModel(this.userId, this.vehicle, this._vehicleService) {
    makeController.text = vehicle.make;
    modelController.text = vehicle.model;
    yearController.text = vehicle.year.toString();
    plateController.text = vehicle.plateNumber;
    heightController.text = vehicle.measurements.height.toString();
    widthController.text = vehicle.measurements.width.toString();
    lengthController.text = vehicle.measurements.length.toString();
    _imageUrl = vehicle.imgUrl;
  }

  String get imageUrl => _imageUrl ?? 'path/to/default/image.png';
  bool get isUploading => _isUploading;

  void updateImageUrl(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  Future<bool> updateVehicle() async {
    _isUploading = true;
    notifyListeners();
    
    Measurements updatedMeasurements = Measurements(
      height: double.parse(heightController.text),
      width: double.parse(widthController.text),
      length: double.parse(lengthController.text),
    );

    Vehicle updatedVehicle = Vehicle(
      id: vehicle.id,
      make: makeController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      plateNumber: plateController.text,
      imgUrl: _imageUrl,
      measurements: updatedMeasurements,
    );

    try {
      await _vehicleService.updateVehicle(userId, updatedVehicle);
      _isUploading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isUploading = false;
      notifyListeners();
      print("Failed to update vehicle: $error");
      return false;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    _isUploading = true;
    notifyListeners();
    try {
      String imageUrl = await _vehicleService.uploadVehicleImage(imageFile, userId, vehicle.id);
      _imageUrl = imageUrl;
      notifyListeners();
      return imageUrl;
    } catch (error) {
      print("Failed to upload image: $error");
      _isUploading = false;
      notifyListeners();
      return '';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    plateController.dispose();
    heightController.dispose();
    widthController.dispose();
    lengthController.dispose();
    super.dispose();
  }
}
