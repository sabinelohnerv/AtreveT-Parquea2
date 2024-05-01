import 'package:parquea2/models/measurements.dart';

class GarageSpace {
  String id;
  Measurements measurements;
  String state;

  GarageSpace({
    required this.id,
    required this.measurements,
    required this.state
  });
}
