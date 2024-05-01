import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/location.dart';

class Garage {
  String id;
  String userId;
  String name;
  String? imgUrl;
  Location location;
  List<String>? details;
  List<GarageSpace> garageSpaces;
  List<AvailableTimeInDay> availableTime;
  int reservationsCompleted;
  double rating;

  Garage({
    required this.id,
    required this.userId,
    required this.name,
    this.imgUrl,
    required this.location,
    this.details,
    required this.garageSpaces,
    required this.availableTime,
    required this.reservationsCompleted,
    required this.rating,
  });
}
