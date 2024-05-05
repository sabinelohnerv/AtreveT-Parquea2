import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/client.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Client?> fetchClientById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('clients').doc(userId).get();
      if (userDoc.exists) {
        return Client.fromSnapshot(userDoc);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> updateClientRating(String clientId, double newRating) async {
    DocumentReference clientRef =
        _firestore.collection('clients').doc(clientId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(clientRef);

        if (!snapshot.exists) {
          throw Exception("Client does not exist!");
        }

        double currentRating = snapshot['averageRating'] as double? ?? 0.0;
        int ratingsCount = snapshot['completedReservations'] as int? ?? 0;

        double totalRating = currentRating * ratingsCount;
        totalRating += newRating;
        ratingsCount += 1;
        double newAverageRating = totalRating / ratingsCount;

        transaction.update(clientRef, {
          'averageRating': newAverageRating,
          'completedReservations': ratingsCount
        });
      });
    } catch (e) {
      print('Error updating client rating: $e');
      throw Exception('Failed to update client rating');
    }
  }
}
