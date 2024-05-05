import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/location.dart';

class Garage {
  String id;
  String userId;
  String? userName;
  String name;
  String? imgUrl;
  Location location;
  List<String>? details;
  List<AvailableTimeInDay> availableTime;
  int numberOfSpaces;
  int reservationsCompleted;
  int ratingsCompleted;
  double rating;

  Garage({
    required this.id,
    required this.userId,
    required this.name,
    this.userName,
    this.imgUrl,
    required this.location,
    this.details,
    required this.availableTime,
    required this.numberOfSpaces,
    required this.reservationsCompleted,
    required this.ratingsCompleted,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'name': name,
      'imgUrl': imgUrl,
      'location': location.toJson(),
      'details': details,
      'availableTimeInWeek': availableTime.map((x) => x.toJson()).toList(),
      'numberOfSpaces': numberOfSpaces,
      'reservationsCompleted': reservationsCompleted,
      'ratingsCompleted': reservationsCompleted,
      'rating': rating,
    };
  }

  factory Garage.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Garage(
      id: snapshot.id,
      userId: data['userId'] as String,
      userName: data['userName'] as String? ?? '',
      name: data['name'] as String,
      imgUrl: data['imgUrl'] as String? ?? '',
      location: Location.fromJson(data['location'] as Map<String, dynamic>),
      details: data['details'] != null
          ? List<String>.from(data['details'] as List)
          : [],
      availableTime: data['availableTimeInWeek'] != null
          ? (data['availableTimeInWeek'] as List)
              .map(
                  (x) => AvailableTimeInDay.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
      numberOfSpaces: data['numberOfSpaces'] as int,
      reservationsCompleted: data['reservationsCompleted'] as int,
      ratingsCompleted: data['ratingsCompleted'] as int ?? 0,
      rating: (data['rating'] as num).toDouble(),
    );
  }
}
