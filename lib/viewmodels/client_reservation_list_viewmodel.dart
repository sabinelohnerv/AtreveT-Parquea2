import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/reservation.dart';
import 'package:parquea2/services/reservation_service.dart';

class ClientReservationListViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  List<Reservation> _reservations = [];
  bool _isLoading = false;
  bool _knownUserId = true;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;

  ClientReservationListViewModel() {
    fetchUserAndListenToReservations();
  }

  Future<void> fetchUserAndListenToReservations() async {
    _isLoading = true;
    notifyListeners();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _knownUserId = true;
      _reservationService.reservationsStreamForClient(userId).listen(
          (reservationData) {
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
}
