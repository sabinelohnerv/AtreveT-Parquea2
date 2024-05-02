import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/measurements.dart';

class GarageSpace {
  String id;
  Measurements measurements;
  List<String>? details;
  String state;

  GarageSpace({
    required this.id,
    required this.measurements,
    this.details,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'measurements': measurements.toJson(),
      'details': details,
      'state': state,
    };
  }

  factory GarageSpace.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    return GarageSpace(
      id: snapshot.id,
      measurements: Measurements.fromJson(json['measurements'] as Map<String, dynamic>),
      details: json['details'] != null
          ? List<String>.from(json['details'] as List)
          : [],
      state: json['state'] as String,
    );
  }
}
