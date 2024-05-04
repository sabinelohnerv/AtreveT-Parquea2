import 'package:flutter/material.dart';
import 'package:parquea2/models/offer.dart';
import 'package:parquea2/services/offer_service.dart';

import '../views/provider_offer_details_view.dart';

class ProviderOfferListViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  List<Offer> _offers = [];
  bool _isLoading = false;
  bool _knownUserId = true;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get knownUserId => _knownUserId;

  ProviderOfferListViewModel(String garageId) {
    fetchOffersForGarage(garageId);
  }

  Future<void> fetchOffersForGarage(String garageId) async {
    _isLoading = true;
    notifyListeners();
    _offerService.offerStreamForGarage(garageId).listen((offerData) {
      _offers = offerData;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      print("Error listening to offer stream: $error");
      notifyListeners();
    });
  }

  void navigateToOfferDetails(BuildContext context, String offerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderOfferDetailsView(offerId: offerId),
      ),
    );
  }
}
