import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage_offer.dart';
import 'package:parquea2/models/user_offer.dart';

class Reservation {
  String id;
  GarageOffer garageSpace;
  UserOffer client;
  UserOffer provider;
  double payAmount;
  String date;
  AvailableTime time;
  String state;

  Reservation({
    required this.id,
    required this.garageSpace,
    required this.client,
    required this.provider,
    required this.payAmount,
    required this.date,
    required this.time,
    required this.state,
  });
}
