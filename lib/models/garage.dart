import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/location.dart';

class Garage {
  String id;
  String userId;
  String name;
  String? imgUrl;
  Location location;
  List<String>? details;
  List<AvailableTimeInDay> availableTime;
  int numberOfSpaces;
  int reservationsCompleted;
  double rating;

  Garage({
    required this.id,
    required this.userId,
    required this.name,
    this.imgUrl,
    required this.location,
    this.details,
    required this.availableTime,
    required this.numberOfSpaces,
    required this.reservationsCompleted,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'imgUrl': imgUrl,
      'location': location.toJson(),
      'details': details,
      'availableTimeInWeek': availableTime.map((x) => x.toJson()).toList(),
      'numberOfSpaces': numberOfSpaces,
      'reservationsCompleted': reservationsCompleted,
      'rating': rating,
    };
  }
}
