import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/provider/edit_garage_space_view.dart';

class GarageSpaceDetailsViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  GarageSpace? _garageSpace;

  GarageSpace? get garageSpace => _garageSpace;

  bool _isCloning = false;

  bool get isCloning => _isCloning;

  void setCloning(bool cloning) {
    _isCloning = cloning;
    notifyListeners();
  }

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

  Future<void> toggleGarageSpaceState(String garageId, String spaceId) async {
    if (_garageSpace != null) {
      String newState =
          _garageSpace!.state == 'deshabilitado' ? 'libre' : 'deshabilitado';
      await _garageService.updateGarageSpaceState(garageId, spaceId, newState);
      _garageSpace!.state = newState;
      notifyListeners();
    }
  }

  Future<void> cloneGarageSpace(
      BuildContext context, String garageId, GarageSpace originalSpace) async {
    setCloning(true);
    GarageSpace newSpace = GarageSpace(
      id: 'Space_${DateTime.now().millisecondsSinceEpoch}',
      measurements: originalSpace.measurements,
      details: originalSpace.details,
      state: originalSpace.state,
    );

    await _garageService.addGarageSpaceAndUpdateSpacesCount(newSpace, garageId);
    setCloning(false);
    Navigator.of(context).pop();
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

  Widget determineState(String garageStateString) {
    String garageState = garageStateString;
    Color textColor;
    String stateText;

    switch (garageState) {
      case 'libre':
        textColor = Colors.green;
        stateText = 'LIBRE';
        break;
      case 'reservado':
        textColor = Colors.orange;
        stateText = 'RESERVADO';
        break;
      case 'ocupado':
        textColor = Colors.blue;
        stateText = 'OCUPADO';
        break;
      case 'deshabilitado':
        textColor = Colors.red;
        stateText = 'DESHABILITADO';
        break;
      default:
        textColor = Colors.grey;
        stateText = 'DESCONOCIDO';
        break;
    }

    return Text(
      stateText.toUpperCase(),
      style: TextStyle(
          color: textColor, fontWeight: FontWeight.w700, fontSize: 26),
    );
  }
}
