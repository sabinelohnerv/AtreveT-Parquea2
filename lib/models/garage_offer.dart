class GarageOffer {
  String garageId;
  String spaceId;
  String garageName;

  GarageOffer({required this.garageId, required this.garageName, required this.spaceId});

  Map<String, dynamic> toJson() {
    return {
      'garageId': garageId,
      'garageName': garageName,
      'spaceId': spaceId,
    };
  }

  factory GarageOffer.fromJson(Map<String, dynamic> json) {
    return GarageOffer(
      garageId: json['garageId'],
      garageName: json['garageName'],
      spaceId: json['spaceId'],
    );
  }
}
