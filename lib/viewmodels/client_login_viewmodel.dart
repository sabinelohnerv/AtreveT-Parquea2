import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientLoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Aquí puedes añadir lógica adicional tras un inicio de sesión exitoso.
      return true;
    } on FirebaseAuthException catch (e) {
      // Manejar diferentes errores de autenticación aquí
      return false;
    }
  }
}
