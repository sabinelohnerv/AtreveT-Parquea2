import 'package:parquea2/models/measurements.dart';

class Vehicle {
  String id;
  String make;
  String model;
  int year;
  String plateNumber;
  Measurements measurements;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.measurements,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: json['make'],
      model: json['model'],
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
      'measurements': measurements.toJson(),
    };
  }
}
