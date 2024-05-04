class UserOffer {
  String id;
  String fullName;
  double? rating;

  UserOffer({required this.id, required this.fullName, this.rating});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'fullName': fullName,
    };
    if (rating != null) {
      data['rating'] = rating;
    }
    return data;
  }

  factory UserOffer.fromJson(Map<String, dynamic> json) {
    return UserOffer(
      id: json['id'],
      fullName: json['fullName'],
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }
}
