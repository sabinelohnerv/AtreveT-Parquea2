import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/provider/add_garage_space_view.dart';

class ClientGarageSpacesListViewModel extends ChangeNotifier {
  final GarageService _garageService;
  List<GarageSpace> _garageSpaces = [];
  List<GarageSpace> get garageSpaces => _garageSpaces;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription<List<GarageSpace>>? _garageSpacesSubscription;

  ClientGarageSpacesListViewModel(String garageId, this._garageService) {
    _subscribeToGarageSpaces(garageId);
  }

  @override
  void dispose() {
    _garageSpacesSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToGarageSpaces(String garageId) {
    _isLoading = true;
    notifyListeners();

    _garageSpacesSubscription =
        _garageService.garagesSpacesStreamByGarage(garageId).listen(
      (garageData) {
        _garageSpaces = garageData;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        print(error);
        notifyListeners();
      },
    );
  }

  void navigateToAddGarageSpace(BuildContext context, String garageId) {
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
