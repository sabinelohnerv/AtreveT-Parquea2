import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/add_garage_space_view.dart';
import 'package:parquea2/views/garage_space_details_view.dart';

class GarageSpacesListViewModel extends ChangeNotifier {
  final GarageService _garageService;
  List<GarageSpace> _garageSpaces = [];
  List<GarageSpace> get garageSpaces => _garageSpaces;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription<List<GarageSpace>>? _garageSpacesSubscription;

  GarageSpacesListViewModel(String garageId, this._garageService) {
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

  Future<void> deleteGarageSpace(String spaceId, String garageId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _garageService.deleteGarageSpaceAndUpdateSpacesCount(
          spaceId, garageId);
      _garageSpaces.removeWhere((space) => space.id == spaceId);
      notifyListeners();
    } catch (e) {
      print('Error deleting garage space: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  void navigateToGarageSpaceDetails(BuildContext context, String garageId, String spaceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GarageSpaceDetails(
          garageId: garageId,
          spaceId: spaceId,
        ),
      ),
    );
  }
}
