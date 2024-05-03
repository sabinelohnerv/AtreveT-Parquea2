import 'package:cloud_firestore/cloud_firestore.dart';
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
}
