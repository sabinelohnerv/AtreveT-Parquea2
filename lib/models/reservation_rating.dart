class ReservationRating {
  double? clientRating;
  double? garageRating;

  ReservationRating({
    this.clientRating,
    this.garageRating,
  });

  factory ReservationRating.fromJson(Map<String, dynamic> json) {
    return ReservationRating(
      clientRating: (json['clientRating'] as num).toDouble(),
      garageRating: (json['garageRating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientRating': clientRating ?? 0,
      'garageRating': garageRating ?? 0,
    };
  }
}
