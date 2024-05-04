// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/models/reservation.dart';
import 'package:parquea2/models/reservation_rating.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/services/offer_service.dart';
import 'package:parquea2/services/reservation_service.dart';

import '../models/client.dart';
import '../models/provider.dart';
import '../services/client_service.dart';
import '../services/provider_service.dart';

class OfferDetailsViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  final ReservationService _reservationService = ReservationService();
  final GarageService _garageService = GarageService();

  final ClientService _clientService = ClientService();
  final ProviderService _providerService = ProviderService();
  String? _clientPhoneNumber;
  String? _providerPhoneNumber;

  Offer? _offer;
  double? _localOfferAmount = 0;

  String? get clientPhoneNumber => _clientPhoneNumber;
  String? get providerPhoneNumber => _providerPhoneNumber;

  Offer? get offer => _offer;
  double get localOfferAmount => _localOfferAmount ?? _offer?.payOffer ?? 0;

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

  void loadOffer(String offerId) {
    _offerService.getOfferById(offerId).listen((offerData) {
      _offer = offerData;
      _localOfferAmount = _offer?.payOffer ?? 0;

      if (_offer != null) {
        fetchClientPhoneNumber(_offer!.client.id);
        fetchProviderPhoneNumber(_offer!.provider.id);
      }
      notifyListeners();
    }, onError: (error) {
      print("Error fetching offer details: $error");
    });
  }

  void incrementOfferAmount(double amount) {
    _localOfferAmount = (_localOfferAmount ?? 0) + amount;
    notifyListeners();
  }

  void decrementOfferAmount(double amount) {
    if ((_localOfferAmount ?? 0) > 0) {
      _localOfferAmount = _localOfferAmount! - amount;
      _localOfferAmount = _localOfferAmount! < 0 ? 0 : _localOfferAmount;
      notifyListeners();
    }
  }

  Future<void> submitCounterOffer(String offerId, String newLastOfferBy) async {
    if (_offer != null) {
      await updatePaymentDetails(offerId, _localOfferAmount!, newLastOfferBy);
      notifyListeners();
    }
  }

  Future<void> acceptCounterOffer(
    String offerId,
    String newLastOfferBy,
    double offerAmount,
  ) async {
    if (_offer != null) {
      await updatePaymentDetails(offerId, offerAmount, newLastOfferBy);
      notifyListeners();
    }
  }

  Future<void> updatePaymentDetails(
      String offerId, double newPayOffer, String newLastOfferBy) async {
    try {
      await _offerService.updateOfferPaymentDetails(
          offerId, newPayOffer, newLastOfferBy);
      _offer!.payOffer = newPayOffer;
      _offer!.lastOfferBy = newLastOfferBy;
      notifyListeners();
    } catch (error) {
      print("Error updating payment details: $error");
    }
  }

  Future<void> updateOfferState(String offerId, String newState) async {
    try {
      await _offerService.updateOfferState(offerId, newState);
      _offer!.state = newState;
      notifyListeners();
    } catch (error) {
      print("Error updating offer state: $error");
    }
  }

  Future<bool> createReservation() async {
    if (_offer == null) {
      print("Offer is null, cannot create reservation.");
      return false;
    }

    final conflictingOffers = await _offerService.findConflictingOffers(
        _offer!.garageSpace.garageId,
        _offer!.garageSpace.spaceId,
        _offer!.date,
        _offer!.time);

    for (var conflictingOffer in conflictingOffers) {
      await _offerService.updateOfferState(
          conflictingOffer.id, 'other-offer-accepted');
    }

    Reservation newReservation = Reservation(
      id: 'Res_${DateTime.now().millisecondsSinceEpoch}',
      garageSpace: _offer!.garageSpace,
      client: _offer!.client,
      vehicle: _offer!.vehicle,
      provider: _offer!.provider,
      payAmount: _offer!.payOffer,
      date: _offer!.date,
      time: _offer!.time,
      rating: ReservationRating(clientRating: 0, garageRating: 0),
      state: 'reserved',
    );

    try {
      await _reservationService.createReservation(newReservation);
      await _offerService.updateOfferState(_offer!.id, 'accepted');
      await _garageService.updateGarageSpaceState(_offer!.garageSpace.garageId,
          _offer!.garageSpace.spaceId, 'reservado');
      notifyListeners();
      return true;
    } catch (error) {
      print("Error creating reservation: $error");
      return false;
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
}
