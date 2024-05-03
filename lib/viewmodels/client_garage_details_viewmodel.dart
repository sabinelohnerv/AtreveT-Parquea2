import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/client_garage_spaces_list_view.dart';

class ClientGarageDetailsViewModel extends ChangeNotifier {
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

  void navigateToGarageSpaces(BuildContext context, Garage garage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientGarageSpacesListView(
          garage: garage,
        ),
      ),
    );
  }
}
