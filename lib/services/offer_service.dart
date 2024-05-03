import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/offer.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create a new offer in the database
  Future<void> createOffer(Offer offer) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offer.id);
      await ref.set(offer.toJson());
    } catch (e) {
      throw Exception('Failed to create offer: $e');
    }
  }

  // Method to update an existing offer
  Future<void> updateOffer(Offer offer) async {
    try {
      DocumentReference ref = _firestore.collection('offers').doc(offer.id);
      await ref.update(offer.toJson());
    } catch (e) {
      throw Exception('Failed to update offer: $e');
    }
  }

  
  Future<Offer?> fetchOfferById(String offerId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('offers').doc(offerId).get();
      if (snapshot.exists) {
        return Offer.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch offer: $e');
    }
  }

  Future<List<Offer>> fetchOffersByClientId(String clientId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('offers')
          .where('client.id', isEqualTo: clientId)
          .get();
      return snapshot.docs
          .map((doc) => Offer.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch offers: $e');
    }
  }
}
