// File: firebase_setup_auth.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
