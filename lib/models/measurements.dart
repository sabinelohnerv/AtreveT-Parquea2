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
      height: (json['height'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
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
