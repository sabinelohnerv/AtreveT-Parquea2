import 'package:parquea2/models/measurements.dart';

class GarageSpace {
  String id;
  String name;
  Measurements measurements;
  List<String>? details;
  String state;

  GarageSpace({
    required this.id,
    required this.name,
    required this.measurements,
    this.details,
    required this.state,
  });
}
