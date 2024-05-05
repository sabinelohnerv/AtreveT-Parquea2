import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class ProviderLoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _firestore
            .collection('providers')
            .doc(userCredential.user!.uid)
            .set({
          'fcmToken': fcmToken,
        }, SetOptions(merge: true));
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Login failed: ${e.message}');
      }
      return false;
    }
  }
}
