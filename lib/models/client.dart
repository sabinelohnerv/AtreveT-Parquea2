class Client {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  double averageRating;
  int completedReservations;

  Client({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.averageRating = 0.0,
    this.completedReservations = 0,
  });
}
