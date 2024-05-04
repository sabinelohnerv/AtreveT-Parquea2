import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/client_garage_spaces_list_view.dart';

import '../models/provider.dart';
import '../services/provider_service.dart';

class ClientGarageDetailsViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  final ProviderService _providerService = ProviderService();

  Garage? _garage;
  Provider? _provider;

  Garage? get garage => _garage;
  Provider? get provider => _provider;

  void loadGarageAndProvider(String garageId) {
    _garageService.getGarageByIdStream(garageId).listen((garageData) {
      _garage = garageData;
      if (_garage != null) {
        loadProvider(_garage!.userId);
      }
      notifyListeners();
    }, onError: (error) {
      print("Error fetching garage details: $error");
    });
  }

  void loadProvider(String userId) {
    _providerService.fetchProviderById(userId).then((providerData) {
      _provider = providerData;
      notifyListeners();
    }).catchError((error) {
      print("Error fetching provider details: $error");
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
