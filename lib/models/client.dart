import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  double averageRating;
  int completedReservations;
  String? fcmToken;
  String role = 'client';

  Client({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.averageRating = 0.0,
    this.completedReservations = 0,
    this.fcmToken,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phoneNumber: json['phoneNumber'] as String,
        averageRating: (json['averageRating'] as num).toDouble(),
        fcmToken: json['fcmToken'] as String,
        completedReservations: (json['completedReservations'] as num).toInt());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'averageRating': averageRating,
      'completedReservations': completedReservations,
      'fcmToken': fcmToken,
      'role': role,
    };
  }

  static Client fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    return Client(
        id: snapshot.id,
        fullName: json['fullName'],
        email: json['email'],
        fcmToken: json['fcmToken'],
        phoneNumber: json['phoneNumber'] as String,
        averageRating: (json['averageRating'] as num).toDouble(),
        completedReservations: (json['completedReservations'] as num).toInt());
  }
}
