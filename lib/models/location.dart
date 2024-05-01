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
}
