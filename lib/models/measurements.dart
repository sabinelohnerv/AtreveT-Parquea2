class Measurements {
  double height;
  double width;
  double length;

  Measurements(
      {required this.height, required this.width, required this.length});

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      length: json['length'].toDouble(),
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
    );
  }
}
