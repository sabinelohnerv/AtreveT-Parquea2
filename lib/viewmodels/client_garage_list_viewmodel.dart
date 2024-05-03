import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/client_garage_details_view.dart';
import 'package:parquea2/views/client_garage_spaces_list_view.dart';

class ClientGarageListViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();

  List<Garage> _garages = [];
  List<Garage> get garages => _garages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClientGarageListViewModel() {
    listenToGarages();
  }

  void listenToGarages() {
    _isLoading = true;
    notifyListeners();

    _garageService.garagesStream().listen((garageData) {
      _garages = garageData;
      _isLoading = false;
      notifyListeners();
    });
  }

  void navigateToGarageDetails(BuildContext context, Garage garage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientGarageDetailsView(
          garage: garage,
        ),
      ),
    );
  }
}
