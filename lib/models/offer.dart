import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage_offer.dart';
import 'package:parquea2/models/user_offer.dart';

class Offer {
  String id;
  GarageOffer garageSpace;
  UserOffer client;
  UserOffer provider;
  String lastOfferBy;
  double payOffer;
  String date;
  AvailableTime time;
  String state;

  Offer({
    required this.id,
    required this.garageSpace,
    required this.client,
    required this.provider,
    required this.lastOfferBy,
    required this.payOffer,
    required this.date,
    required this.time,
    required this.state,
  });
}
