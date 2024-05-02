class Location {
  String location;
  String coordinates;
  String? reference;

  Location({
    required this.location,
    required this.coordinates,
    this.reference,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'coordinates': coordinates,
      'reference': reference,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      location: json['location'] as String,
      coordinates: json['coordinates'] as String,
      reference: json['reference'] as String? ?? '',
    );
  }
}
