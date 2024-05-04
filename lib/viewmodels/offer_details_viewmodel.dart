import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/services/offer_service.dart';

class OfferDetailsViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  Offer? _offer;

  Offer? get offer => _offer;

  void loadOffer(String offerId) {
    _offerService.getOfferById(offerId).listen((offerData) {
      _offer = offerData;
      notifyListeners();
    }, onError: (error) {
      print("Error fetching offer details: $error");
    });
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

  Future<void> updatePaymentDetails(
      String offerId, double newPayOffer, String newLastOfferBy) async {
    try {
      await _offerService.updateOfferPaymentDetails(
          offerId, newPayOffer, newLastOfferBy);
      notifyListeners();
    } catch (error) {
      print("Error updating payment details: $error");
    }
  }
}
