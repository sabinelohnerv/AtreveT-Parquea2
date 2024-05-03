import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/services/offer_service.dart';

class ProviderOfferListViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  List<Offer> _offers = [];
  bool _isLoading = false;
  bool _knownUserId = true;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;

  ProviderOfferListViewModel() {
    fetchUserAndListenToOffers();
  }

  Future<void> fetchUserAndListenToOffers() async {
    _isLoading = true;
    notifyListeners();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      _knownUserId = true;
      _offerService.offerStreamForProvider(userId).listen((offerData) {
        _offers = offerData;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        print("Error listening to offer stream: $error");
        _isLoading = false;
        notifyListeners();
      });
    }
  }
}
