// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parquea2/models/reservation.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/reservation_service.dart';

import '../models/client.dart';
import '../models/provider.dart';
import '../services/client_service.dart';
import '../services/provider_service.dart';

class ReservationDetailsViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  final GarageService _garageService = GarageService();

  final ClientService _clientService = ClientService();
  final ProviderService _providerService = ProviderService();
  String? _clientPhoneNumber;
  String? _providerPhoneNumber;

  Reservation? _reservation;

  String? get clientPhoneNumber => _clientPhoneNumber;
  String? get providerPhoneNumber => _providerPhoneNumber;

  Reservation? get reservation => _reservation;

  Future<void> fetchClientPhoneNumber(String clientId) async {
    try {
      Client? client = await _clientService.fetchClientById(clientId);
      _clientPhoneNumber = client?.phoneNumber;
      notifyListeners();
    } catch (e) {
      print('Error fetching client phone number: $e');
    }
  }

  Future<void> fetchProviderPhoneNumber(String providerId) async {
    try {
      Provider? provider = await _providerService.fetchProviderById(providerId);
      _providerPhoneNumber = provider?.phoneNumber;
      notifyListeners();
    } catch (e) {
      print('Error fetching provider phone number: $e');
    }
  }

  void loadReservation(String reservationId) {
    _reservationService.getReservationById(reservationId).listen(
        (reservationData) {
      _reservation = reservationData;

      if (_reservation != null) {
        fetchClientPhoneNumber(_reservation!.client.id);
        fetchProviderPhoneNumber(_reservation!.provider.id);
      }
      notifyListeners();
    }, onError: (error) {
      print("Error fetching reservation details: $error");
    });
  }

  Future<void> updateReservationState(
      String reservationId, String newState) async {
    try {
      await _reservationService.updateReservationState(reservationId, newState);
      _reservation!.state = newState;
      notifyListeners();
    } catch (error) {
      print("Error updating reservation state: $error");
    }
  }

  Future<void> updateGarageSpaceState(
      String garageId, String spaceId, String newState) async {
    try {
      await _garageService.updateGarageSpaceState(garageId, spaceId, newState);
      notifyListeners();
    } catch (error) {
      print("Error updating reservation state: $error");
    }
  }

  Future<void> updateClientRating(String clientId, double rating) async {
    await _clientService.updateClientRating(clientId, rating);
  }

  Future<void> updateReservationClientRating(
      String reservationId, double rating) async {
    await _reservationService.updateReservationClientRating(
        reservationId, rating);
  }

  Future<void> updateReservationGarageRating(
      String garageId, double rating) async {
    await _reservationService.updateReservationClientRating(garageId, rating);
  }

  Future<void> updateGarageRating(String garageId, double rating) async {
    await _garageService.updateGarageRating(garageId, rating);
  }

  Future<void> updateGarageReservationsCompleted(String garageId) async {
    try {
      await _garageService.updateGarageReservationsCompleted(garageId);
      notifyListeners();
    } catch (error) {
      print("Error updating reservation state: $error");
    }
  }

  void showSnackbar(BuildContext context, String message, Color color,
      {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: action,
        backgroundColor: color,
      ),
    );
  }

  Future<void> finalizeReservation(
      BuildContext context,
      String clientId,
      String reservationId,
      String garageId,
      String spaceId,
      double rating) async {
    try {
      await updateReservationState(reservationId, 'needs-rating');
      await updateGarageReservationsCompleted(garageId);
      await updateGarageSpaceState(garageId, spaceId, 'libre');
      await updateClientRating(clientId, rating);
      showSnackbar(context, 'Reserva finalizada y cliente calificado con éxito',
          Colors.green);
    } catch (error) {
      showSnackbar(
          context, 'No se pudo finalizar la reserva: $error', Colors.red);
    }
  }

  Future<void> finalizeReservationClient(BuildContext context,
      String reservationId, String garageId, double rating) async {
    try {
      await updateReservationState(reservationId, 'finalized');
      await updateGarageRating(garageId, rating);
      showSnackbar(context, 'Reserva finalizada y garaje calificado con éxito',
          Colors.green);
    } catch (error) {
      showSnackbar(
          context, 'No se pudo finalizar la reserva: $error', Colors.red);
    }
  }
}
