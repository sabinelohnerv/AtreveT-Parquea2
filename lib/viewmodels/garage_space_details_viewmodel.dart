import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/edit_garage_space_view.dart';

class GarageSpaceDetailsViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  GarageSpace? _garageSpace;

  GarageSpace? get garageSpace => _garageSpace;

  void loadGarageSpace(String garageId, String spaceId) {
    _garageService.getGarageSpaceByIdStream(garageId, spaceId).listen(
        (garageSpaceData) {
      _garageSpace = garageSpaceData;
      notifyListeners();
    }, onError: (error) {
      print("Error fetching garagespace details: $error");
    });
  }

  Future<void> deleteGarageSpace(String garageId, String spaceId) async {
    try {
      await _garageService.deleteGarageSpaceAndUpdateSpacesCount(
          garageId, spaceId);
      _garageSpace = null;
      notifyListeners();
    } catch (e) {
      print("Error deleting garagespace: $e");
    }
  }

  void navigateToEditGarageSpace(BuildContext context, String garageId) {
    if (_garageSpace != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditGarageSpaceView(
            garageId: garageId,
            garageSpace: _garageSpace!,
          ),
        ),
      );
    } else {
      return;
    }
  }
}
