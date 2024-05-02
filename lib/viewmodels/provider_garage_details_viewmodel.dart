import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/add_garage_space_view.dart';

class GarageDetailsViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  Garage? _garage;

  Garage? get garage => _garage;

  void loadGarage(String garageId) {
    _garageService.getGarageByIdStream(garageId).listen((garageData) {
      _garage = garageData;
      notifyListeners();
    }, onError: (error) {
      print("Error fetching garage details: $error");
    });
  }

  Future<void> deleteGarage(String garageId) async {
    try {
      await _garageService.deleteGarage(garageId);
      _garage = null;
      notifyListeners();
    } catch (e) {
      print("Error deleting garage: $e");
    }
  }

  void navigateToGarageSpaces(BuildContext context, String garageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGarageSpaceView(),
      ),
    );
  }
}
