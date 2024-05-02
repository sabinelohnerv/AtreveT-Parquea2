import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/add_garage_space_view.dart';

class GarageSpacesListViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  final garageId;

  List<GarageSpace> _garageSpaces = [];
  List<GarageSpace> get garageSpaces => _garageSpaces;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GarageSpacesListViewModel(this.garageId) {
    listenToGarageSpaces(garageId);
  }

  void listenToGarageSpaces(String garageId) {
    _isLoading = true;
    notifyListeners();

    _garageService.garagesSpacesStreamByGarage(garageId).listen((garageData) {
      _garageSpaces = garageData;
      _isLoading = false;
      notifyListeners();
    });
  }

  void navigateToAddGarageSpace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGarageSpaceView(
          garageId: garageId,
        ),
      ),
    );
  }
}
