import 'package:chat_app/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User1? _userFromFirebaseUser(User? user) {
    return (user != null) ? User1(userId: user.uid) : null;
  }
  // User1 fuction se nullable datatype bhi return kiya jaa skya hai so we write User1 ? .

  Future<User1?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? _firebaseUser = result.user;
      return _userFromFirebaseUser(_firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User1?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? _firebaseUser = result.user;
      return _userFromFirebaseUser(_firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
