import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/reservation.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/reservation_service.dart';
import 'package:parquea2/views/provider_reservation_details_view.dart';

class ProviderReservationListViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  final GarageService _garageService = GarageService();

  List<Reservation> _reservations = [];
  List<GarageSpace> _garageSpaces = [];
  Map<String, List<Reservation>> spaceToReservationsMap = {};
  bool _isLoading = false;
  bool _knownUserId = true;

  List<Reservation> get reservations => _reservations;
  List<GarageSpace> get garageSpaces => _garageSpaces;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;

  ProviderReservationListViewModel(String garageId) {
    initializeData(garageId);
  }

  Future<void> initializeData(String garageId) async {
    fetchUserAndListenToReservations(garageId);
    fetchGarageSpaces(garageId);
  }

  Future<void> fetchUserAndListenToReservations(String garageId) async {
    _isLoading = true;
    notifyListeners();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _knownUserId = true;
      _reservationService
          .reservationsStreamByGarageForProvider(userId, garageId)
          .listen((reservationData) {
        _reservations = reservationData;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        print("Error listening to reservation stream: $error");
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _knownUserId = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGarageSpaces(String garageId) async {
    _garageService.garagesSpacesStreamByGarage(garageId).listen(
        (garageSpacesData) {
      _garageSpaces = garageSpacesData;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to garage spaces stream: $error");
    });
  }

  int getSpaceIndex(String spaceId) {
    return _garageSpaces.indexWhere((space) => space.id == spaceId) + 1;
  }

  void navigateToReservationDetails(
      BuildContext context, String reservationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProviderReservationDetailsView(reservationId: reservationId),
      ),
    );
  }
}
