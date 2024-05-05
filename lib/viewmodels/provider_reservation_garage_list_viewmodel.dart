import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/models/reservation.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/reservation_service.dart';
import 'package:parquea2/views/provider_reservation_list.dart';

class ReservationGarageListViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();
  final ReservationService _reservationService = ReservationService();

  List<Reservation> _reservations = [];
  List<Garage> _garages = [];
  bool _isLoading = false;
  bool _knownUserId = true;
  Map<String, int> _reservationCounts = {};

  List<Garage> get garages => _garages;
  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;
  Map<String, int> get reservationCounts => _reservationCounts;

  ReservationGarageListViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    fetchUserAndListenToGarages();
    fetchUserAndListenToReservations();
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

  Future<void> fetchUserAndListenToReservations() async {
    _isLoading = true;
    notifyListeners();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _knownUserId = true;
      _reservationService.reservationsStreamForProvider(userId).listen(
          (reservationData) {
        _reservations = reservationData;
        countReservationsPerGarage();
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

  void countReservationsPerGarage() {
    _reservationCounts.clear();

    for (var reservation in _reservations) {
      _reservationCounts.update(
        reservation.garageSpace.garageId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    notifyListeners();
  }

  void navigateToReservationsPerGarage(BuildContext context, String garageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderReservationListView(garageId: garageId),
      ),
    );
  }
}
