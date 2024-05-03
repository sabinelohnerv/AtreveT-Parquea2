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
}
