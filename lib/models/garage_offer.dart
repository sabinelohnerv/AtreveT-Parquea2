class GarageOffer {
  String garageId;
  String spaceId;

  GarageOffer({required this.garageId, required this.spaceId});

  Map<String, dynamic> toJson() {
    return {
      'garageId': garageId,
      'spaceId': spaceId,
    };
  }

  factory GarageOffer.fromJson(Map<String, dynamic> json) {
    return GarageOffer(
      garageId: json['garageId'],
      spaceId: json['spaceId'],
    );
  }
}
