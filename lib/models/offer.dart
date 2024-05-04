import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage_offer.dart';
import 'package:parquea2/models/user_offer.dart';
import 'package:parquea2/models/vehicle.dart';

class Offer {
  String id;
  GarageOffer garageSpace;
  UserOffer client;
  Vehicle vehicle;
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
    required this.vehicle,
    required this.provider,
    required this.lastOfferBy,
    required this.payOffer,
    required this.date,
    required this.time,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'garageSpace': garageSpace.toJson(),
      'client': client.toJson(),
      'vehicle': vehicle.toJson(),
      'provider': provider.toJson(),
      'lastOfferBy': lastOfferBy,
      'payOffer': payOffer,
      'date': date,
      'time': time.toJson(),
      'state': state,
    };
  }

  factory Offer.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    try {
      return Offer(
        id: snapshot.id,
        garageSpace:
            GarageOffer.fromJson(json['garageSpace'] as Map<String, dynamic>),
        client: UserOffer.fromJson(json['client'] as Map<String, dynamic>),
        vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
        provider: UserOffer.fromJson(json['provider'] as Map<String, dynamic>),
        lastOfferBy: json['lastOfferBy'] as String,
        payOffer: (json['payOffer'] as num).toDouble(),
        date: json['date'] as String,
        time: AvailableTime.fromJson(json['time'] as Map<String, dynamic>),
        state: json['state'] as String,
      );
    } catch (e) {
      rethrow;
    }
  }
}
