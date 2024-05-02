// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/models/measurements.dart';
import 'package:parquea2/services/vehicle_service.dart';

class AddVehicleViewModel extends ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();

  bool _isUploading = false;
  String? _imgUrl = '';
  File? imagePath;

  // Text editing controllers for vehicle properties and measurements
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController plateController = TextEditingController();

  // Getters for UI updates
  bool get isUploading => _isUploading;
  String get imgUrl => _imgUrl ?? 'path/to/default/image.png';

  // Methods to handle manual and API data updates
  void updateVehicleFromApi(Map<String, dynamic> apiData) {
    makeController.text = apiData['make'];
    modelController.text = apiData['model'];
    yearController.text = apiData['year'];
    heightController.text = apiData['height'].toString();
    widthController.text = apiData['width'].toString();
    lengthController.text = apiData['length'].toString();
    notifyListeners();
  }

  Future<void> uploadVehicleImage(String userId, String vehicleId) async {
    if (imagePath != null) {
      _imgUrl = await _vehicleService.uploadVehicleImage(
          imagePath!, userId, vehicleId);
      notifyListeners();
    }
  }

  void setImagePath(File imagePath) {
    imagePath = imagePath;
    notifyListeners();
  }

  Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void resetData() {
    makeController.clear();
    modelController.clear();
    yearController.clear();
    heightController.clear();
    widthController.clear();
    lengthController.clear();
    plateController.clear();
    imagePath = null;
    _imgUrl = null;
    notifyListeners();
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    heightController.dispose();
    widthController.dispose();
    lengthController.dispose();
    plateController.dispose();

    super.dispose();
  }

  Future<void> addVehicle(ScaffoldMessengerState scaffoldMessenger) async {
    _isUploading = true;
    notifyListeners();

    String userId = await getUserId();
    if (userId.isEmpty) {
      _showSnackbar(scaffoldMessenger, "Failed to get user ID", Colors.red);
      _isUploading = false;
      notifyListeners();
      return;
    }

    try {
      String vehicleId = "Vehicle_${DateTime.now().millisecondsSinceEpoch}";
      Measurements measurements = Measurements(
          height: double.parse(heightController.text),
          width: double.parse(widthController.text),
          length: double.parse(lengthController.text));

      Vehicle newVehicle = Vehicle(
          id: vehicleId,
          make: makeController.text,
          model: modelController.text,
          year: int.tryParse(yearController.text) ?? DateTime.now().year,
          measurements: measurements,
          plateNumber: plateController.text);

      await _vehicleService.addVehicle(userId, newVehicle);
      _showSnackbar(
          scaffoldMessenger, "VEHICULO REGISTRADO CON EXITO", Colors.green);
      resetData();
    } catch (e) {
      _showSnackbar(
          scaffoldMessenger, "REGISTRO FALLIDO, REVISE SUS DATOS", Colors.red);
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void _showSnackbar(
      ScaffoldMessengerState scaffoldMessenger, String message, Color color) {
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
