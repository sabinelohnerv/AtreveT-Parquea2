import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parquea2/models/available_time.dart';
import 'package:parquea2/models/offer.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOffer(Offer offer) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offer.id);
      await ref.set(offer.toJson());
    } catch (e) {
      throw Exception('Failed to create offer: $e');
    }
  }

  Future<void> updateOffer(Offer offer) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offer.id);
      await ref.update(offer.toJson());
    } catch (e) {
      throw Exception('Failed to update offer: $e');
    }
  }

  Future<void> updateOfferState(String offerId, String newState) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offerId);
      await ref.update({'state': newState});
    } catch (e) {
      throw Exception('Failed to update offer state: $e');
    }
  }

  Future<void> updateOfferPaymentDetails(
      String offerId, double newPayOffer, String newLastOfferBy) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offerId);
      Map<String, dynamic> updates = {
        'payOffer': newPayOffer,
        'lastOfferBy': newLastOfferBy
      };
      await ref.update(updates);
    } catch (e) {
      throw Exception('Failed to update offer payment details: $e');
    }
  }

  Stream<Offer?> getOfferById(String offerId) {
    return _firestore
        .collection('offers')
        .doc(offerId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Offer.fromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }

  Stream<List<Offer>> offerStreamForClient(String userId) {
    return _firestore
        .collection('offers')
        .where('client.id', isEqualTo: userId)
        .where('state', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Offer.fromSnapshot(doc)).toList());
  }

  Stream<List<Offer>> offerStreamForProvider(String userId) {
    return _firestore
        .collection('offers')
        .where('provider.id', isEqualTo: userId)
        .where('state', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Offer.fromSnapshot(doc)).toList());
  }

  Future<List<Offer>> findConflictingOffers(
      String garageId, String spaceId, String date, AvailableTime time) async {
    try {
      TimeOfDay startTime = TimeOfDay(
          hour: int.parse(time.startTime.split(':')[0]),
          minute: int.parse(time.startTime.split(':')[1]));
      TimeOfDay endTime = TimeOfDay(
          hour: int.parse(time.endTime.split(':')[0]),
          minute: int.parse(time.endTime.split(':')[1]));

      List<Offer> conflictingOffers = [];
      final querySnapshot = await _firestore
          .collection('offers')
          .where('garageSpace.garageId', isEqualTo: garageId)
          .where('garageSpace.spaceId', isEqualTo: spaceId)
          .where('date', isEqualTo: date)
          .where('state', isEqualTo: 'active')
          .get();

      for (var doc in querySnapshot.docs) {
        var offer = Offer.fromSnapshot(doc);
        TimeOfDay offerStartTime = TimeOfDay(
            hour: int.parse(offer.time.startTime.split(':')[0]),
            minute: int.parse(offer.time.startTime.split(':')[1]));
        TimeOfDay offerEndTime = TimeOfDay(
            hour: int.parse(offer.time.endTime.split(':')[0]),
            minute: int.parse(offer.time.endTime.split(':')[1]));

        if (startTime.hour < offerEndTime.hour ||
            (startTime.hour == offerEndTime.hour &&
                startTime.minute < offerEndTime.minute)) {
          if (endTime.hour > offerStartTime.hour ||
              (endTime.hour == offerStartTime.hour &&
                  endTime.minute > offerStartTime.minute)) {
            conflictingOffers.add(offer);
          }
        }
      }
      return conflictingOffers;
    } catch (e) {
      print("Error fetching conflicting offers: $e");
      return [];
    }
  }
}
