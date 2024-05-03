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

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      garageSpace: GarageOffer.fromJson(json['garageSpace']),
      client: UserOffer.fromJson(json['client']),
      vehicle: Vehicle.fromJson(json['vehicle']),
      provider: UserOffer.fromJson(json['provider']),
      lastOfferBy: json['lastOfferBy'],
      payOffer: (json['payOffer'] as num).toDouble(),
      date: json['date'],
      time: AvailableTime.fromJson(json['time']),
      state: json['state'],
    );
  }

  factory Offer.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    return Offer(
      id: snapshot.id,
      garageSpace: GarageOffer.fromJson(json['garageSpace']),
      client: UserOffer.fromJson(json['client']),
      vehicle: Vehicle.fromJson(json['vehicle']),
      provider: UserOffer.fromJson(json['provider']),
      lastOfferBy: json['lastOfferBy'],
      payOffer: (json['payOffer'] as num).toDouble(),
      date: json['date'],
      time: AvailableTime.fromJson(json['time']),
      state: json['state'],
    );
  }
}
