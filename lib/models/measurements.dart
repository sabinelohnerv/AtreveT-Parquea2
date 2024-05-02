class Measurements {
  double height;
  double width;
  double length;

  Measurements({
    required this.height,
    required this.width,
    required this.length,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      height: double.parse(json['height']),
      width: double.parse(json['width']),
      length: double.parse(json['length']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'width': width,
      'length': length,
    };
  }
}
