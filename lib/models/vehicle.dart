import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/measurements.dart';

class Vehicle {
  String id;
  String make;
  String model;
  int year;
  String plateNumber;
  String? imgUrl;
  Measurements measurements;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    this.imgUrl,
    required this.measurements,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      imgUrl: json['imgUrl'],
      year: int.parse(json['year']),
      plateNumber: json['plateNumber'],
      measurements: Measurements.fromJson(json['measurements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'plateNumber': plateNumber,
      'imgUrl': imgUrl,
      'measurements': measurements.toJson(),
    };
  }

  factory Vehicle.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      id: doc.id,
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      year:
          data['year'] != null ? int.tryParse(data['year'].toString()) ?? 0 : 0,
      plateNumber: data['plateNumber'] ?? '',
      measurements:
          Measurements.fromJson(data['measurements'] as Map<String, dynamic>),
    );
  }
}
