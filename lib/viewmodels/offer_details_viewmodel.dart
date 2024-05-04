import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/services/offer_service.dart';

class OfferDetailsViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  Offer? _offer;
  double? _localOfferAmount = 0;

  Offer? get offer => _offer;
  double get localOfferAmount => _localOfferAmount ?? _offer?.payOffer ?? 0;

  void loadOffer(String offerId) {
    _offerService.getOfferById(offerId).listen((offerData) {
      _offer = offerData;
      _localOfferAmount = _offer?.payOffer ?? 0;
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
}
