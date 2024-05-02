import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/vehicle.dart';
import 'package:parquea2/services/vehicle_service.dart';
import 'package:parquea2/views/add_vehicle_view.dart';
import 'package:parquea2/views/user_vehicle_details_view.dart';

class VehicleListViewModel extends ChangeNotifier {
  final VehicleService _vehicleService;
  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _userId = '';
  String get userId => _userId;

  bool _knownUserId = true;
  bool get knownUserId => _knownUserId;

  StreamSubscription<List<Vehicle>>? _vehicleSubscription;

  VehicleListViewModel(this._vehicleService) {
    _fetchUserAndListenToVehicles();
  }

  @override
  void dispose() {
    _vehicleSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserAndListenToVehicles() async {
    _isLoading = true;
    notifyListeners();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    notifyListeners();

    if (_userId.isNotEmpty) {
      _knownUserId = true;
      _vehicleSubscription =
          _vehicleService.streamVehicles(_userId).listen((vehicleData) {
        _vehicles = vehicleData;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        print("Error listening to vehicle stream: $error");
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _knownUserId = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToAddVehicle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVehicleView()),
    );
  }

    void navigateToVehicleDetails(BuildContext context, String vehicleId) {
      _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      notifyListeners();
      if (_userId.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsView(
              vehicleId: vehicleId,
              userId: _userId,
            ),
          ),
        );
      } else {
        return;
      }
    }
}
