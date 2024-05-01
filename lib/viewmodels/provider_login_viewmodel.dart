import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderLoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }
}
