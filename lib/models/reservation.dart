import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage_offer.dart';
import 'package:parquea2/models/reservation_rating.dart';
import 'package:parquea2/models/user_offer.dart';
import 'package:parquea2/models/vehicle.dart';

class Reservation {
  String id;
  GarageOffer garageSpace;
  UserOffer client;
  Vehicle vehicle;
  UserOffer provider;
  double payAmount;
  String date;
  AvailableTime time;
  ReservationRating? rating;
  String state;

  Reservation({
    required this.id,
    required this.garageSpace,
    required this.client,
    required this.vehicle,
    required this.provider,
    required this.payAmount,
    required this.date,
    required this.time,
    this.rating,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'garageSpace': garageSpace.toJson(),
      'client': client.toJson(),
      'vehicle': vehicle.toJson(),
      'provider': provider.toJson(),
      'payAmount': payAmount,
      'date': date,
      'time': time.toJson(),
      'rating': rating!.toJson(),
      'state': state,
    };
  }

  factory Reservation.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    try {
      return Reservation(
        id: snapshot.id,
        garageSpace:
            GarageOffer.fromJson(json['garageSpace'] as Map<String, dynamic>),
        client: UserOffer.fromJson(json['client'] as Map<String, dynamic>),
        vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
        provider: UserOffer.fromJson(json['provider'] as Map<String, dynamic>),
        payAmount: (json['payAmount'] as num).toDouble(),
        date: json['date'] as String,
        time: AvailableTime.fromJson(json['time'] as Map<String, dynamic>),
        rating:
            ReservationRating.fromJson(json['rating'] as Map<String, dynamic>),
        state: json['state'] as String,
      );
    } catch (e) {
      rethrow;
    }
  }
}
