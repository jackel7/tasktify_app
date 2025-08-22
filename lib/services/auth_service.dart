import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered. Please log in or use a different email.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        default:
          return e.message ??
              'An authentication error occurred.';
      }
    }
    // Remove generic catch to avoid capturing unexpected errors
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return e.message ??
              'An authentication error occurred.';
      }
    } catch (e, stackTrace) {
      debugPrint(
        "Unexpected login error: $e\n$stackTrace",
      );
      return 'Something went wrong. Please try again later.';
    }
  }
}
