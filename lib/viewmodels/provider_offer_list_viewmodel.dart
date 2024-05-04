import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/services/offer_service.dart';
import 'package:parquea2/views/provider_offer_details_view.dart';

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
        _isLoading = false;
        print(error);
        notifyListeners();
      });
    }
  }

  void navigateToOfferDetails(BuildContext context, String offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderOfferDetailsView(
          offerId: offerId,
        ),
      ),
    );
  }
}
