import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderRegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> registerProvider(String email, String password, String fullName,
      String phoneNumber) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore
          .collection('providers')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'averageRating': 0.0,
        'completedReservations': 0,
        'role': 'provider',
      });
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
