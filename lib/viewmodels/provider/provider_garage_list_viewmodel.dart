import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/provider/add_garage_view.dart';
import 'package:parquea2/views/provider/provider_garage_details_view.dart';

class GarageListViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  List<Garage> _garages = [];
  bool _isLoading = false;
  bool _knownUserId = true;

  List<Garage> get garages => _garages;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;

  GarageListViewModel() {
    fetchUserAndListenToGarages();
  }

  Future<void> fetchUserAndListenToGarages() async {
    _isLoading = true;
    notifyListeners();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _knownUserId = true;
      _garageService.garagesStreamByUserId(userId).listen((garageData) {
        _garages = garageData;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        print("Error listening to garage stream: $error");
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _knownUserId = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGarage(String garageId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _garageService.deleteGarage(garageId);
      _garages.removeWhere((garage) => garage.id == garageId);
    } catch (e) {
      print('Error deleting garage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToAddGarage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGarageView()),
    );
  }

  void navigateToGarageDetails(BuildContext context, String garageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GarageDetails(garageId: garageId),
      ),
    );
  }
}
