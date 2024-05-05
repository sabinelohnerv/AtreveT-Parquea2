import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? fcmToken = await _firebaseMessaging.getToken();
      DocumentSnapshot clientDoc = await _firestore
          .collection('clients')
          .doc(userCredential.user!.uid)
          .get();
      DocumentSnapshot providerDoc = await _firestore
          .collection('providers')
          .doc(userCredential.user!.uid)
          .get();

      String role = clientDoc.exists
          ? 'client'
          : providerDoc.exists
              ? 'provider'
              : throw Exception('User not found in any collection');

      await _firestore
          .collection(role == 'client' ? 'clients' : 'providers')
          .doc(userCredential.user!.uid)
          .set({'fcmToken': fcmToken}, SetOptions(merge: true));

      switch (role) {
        case 'client':
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 'provider':
          Navigator.pushReplacementNamed(context, '/home');
          break;
        default:
          throw Exception('Unknown user role');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Login failed: ${e.message}');
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login failed: ${e.message}")));
    }
  }
}
