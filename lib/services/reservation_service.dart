import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:parquea2/models/reservation.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createReservation(Reservation reservation) async {
    try {
      DocumentReference ref =
          _firestore.collection('reservations').doc(reservation.id);
      await ref.set(reservation.toJson());
    } catch (e) {
      throw Exception('Failed to create reservation: $e');
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    try {
      DocumentReference ref =
          _firestore.collection('reservations').doc(reservation.id);
      await ref.update(reservation.toJson());
    } catch (e) {
      throw Exception('Failed to update reservation: $e');
    }
  }

  Future<void> updateReservationState(
      String reservationId, String newState) async {
    try {
      DocumentReference ref =
          _firestore.collection('reservations').doc(reservationId);
      await ref.update({'state': newState});
    } catch (e) {
      throw Exception('Failed to update reservation state: $e');
    }
  }

  Stream<Reservation?> getReservationById(String reservationId) {
    return _firestore
        .collection('reservations')
        .doc(reservationId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Reservation.fromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }

  Stream<List<Reservation>> reservationsStreamForClient(String clientId) {
    return _firestore
        .collection('reservations')
        .where('client.id', isEqualTo: clientId)
        .where('state', whereIn: ["active", "reserved", "needs-rating"])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reservation.fromSnapshot(doc)).toList());
  }

  Stream<List<Reservation>> reservationsStreamByGarageForProvider(
      String providerId, String garageId) {
    return _firestore
        .collection('reservations')
        .where('provider.id', isEqualTo: providerId)
        .where('garageSpace.garageId', isEqualTo: garageId)
        .where('state', whereIn: ["active", "reserved"])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reservation.fromSnapshot(doc)).toList());
  }

  Stream<List<Reservation>> reservationsStreamForProvider(String providerId) {
    return _firestore
        .collection('reservations')
        .where('provider.id', isEqualTo: providerId)
        .where('state', whereIn: ["active", "reserved"])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reservation.fromSnapshot(doc)).toList());
  }

  Future<void> deleteReservation(String reservationId) async {
    try {
      DocumentReference ref =
          _firestore.collection('reservations').doc(reservationId);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete reservation: $e');
    }
  }
}
