import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/client.dart';
import 'package:parquea2/services/client_service.dart';
import 'package:parquea2/views/client/client_garage_list_view.dart';
import 'package:parquea2/views/client/client_offer_list_view.dart';
import 'package:parquea2/views/client/client_reservation_list_view.dart';
import 'package:parquea2/views/client/client_vehicles_list_view.dart';

class ClientViewModel extends ChangeNotifier {
  final _clientService = ClientService();
  Client? _currentClient;
  Map<String, dynamic>? _clientDetails;

  Client? get currentClient => _currentClient;
  Map<String, dynamic>? get clientDetails => _clientDetails;

  ClientViewModel() {
    loadCurrentClient();
  }

  Future<void> loadCurrentClient() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _currentClient = Client(id: '', fullName: '', phoneNumber: '', email: '');
    if (userId.isNotEmpty) {
      Client? client = await _clientService.fetchClientById(userId);
      notifyListeners();
      if (client != null) {
        _currentClient?.id = client.id;
        _currentClient?.fullName = client.fullName;
        _currentClient?.phoneNumber = client.phoneNumber;
        _currentClient?.email = client.email;
        notifyListeners();
      }
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }

  void navigateToGarageList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClientGarageListView()),
    );
  }

  void navigateToVehicleList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehicleListView()),
    );
  }

  navigateToOfferList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClientOfferListView()),
    );
  }

  navigateToReservationList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ClientReservationListView()),
    );
  }
}
