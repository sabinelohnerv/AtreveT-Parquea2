class UserOffer {
  String id;
  String fullName;

  UserOffer({required this.id, required this.fullName});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
    };
  }

  factory UserOffer.fromJson(Map<String, dynamic> json) {
    return UserOffer(
      id: json['id'],
      fullName: json['fullName'],
    );
  }
}
