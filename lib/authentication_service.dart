import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'signed in';
    } on FirebaseAuthException catch (e) {
      throw exitCode; // TODO: Fix this // TODO: Fix this
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw e; // TODO: Fix this
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
