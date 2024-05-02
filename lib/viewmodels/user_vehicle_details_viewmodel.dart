import 'package:flutter/material.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/vehicle_service.dart';

class VehicleDetailsViewModel extends ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();
  Vehicle? _vehicle;

  Vehicle? get vehicle => _vehicle;

  void loadVehicle(String vehicleId, String userId) {
    _vehicleService.getVehicleByIdStream(userId, vehicleId).listen((vehicleData) {
      _vehicle = vehicleData;
      notifyListeners();
    }, onError: (error) {
      print("Error fetching vehicle details: $error");
    });
  }

  Future<void> deleteVehicle(String vehicleId, String userId) async {
    try {
      await _vehicleService.deleteVehicle(userId, vehicleId);
      _vehicle = null;
      notifyListeners();
    } catch (e) {
      print("Error deleting vehicle: $e");
    }
  }
}
