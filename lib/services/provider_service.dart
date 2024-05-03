import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parquea2/models/provider.dart';

class ProviderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Provider?> fetchProviderById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('providers').doc(userId).get();
      if (userDoc.exists) {
        return Provider.fromSnapshot(userDoc);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
