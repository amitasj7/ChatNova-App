import 'package:chat_app/Model/user.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User1? _userFromFirebaseUser(User? user) {
    return (user != null) ? User1(userId: user.uid) : null;
  }
  // User1 fuction se nullable datatype bhi return kiya jaa skya hai so we write User1 ? .

  Future<User1?> signInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? _firebaseUser = result.user;
      // print("aaja bsdk");
      return _userFromFirebaseUser(_firebaseUser);
    } catch (e) {
      // print("hey bsdk");
      openSnackBar(
        context,
        e.toString(),
        const Color.fromARGB(255, 255, 210, 150),
      );
      // print(e.toString());
    }
    return null;
  }

  Future<User1?> signUpWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? _firebaseUser = result.user;
      return _userFromFirebaseUser(_firebaseUser);
    } catch (e) {
      openSnackBar(
        context,
        e.toString(),
        const Color.fromARGB(255, 255, 210, 150),
      );
      // print(e.toString());
    }
    return null;
  }

  Future<void> resetPass(String email,context) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
       openSnackBar(
        context,
        e.toString(),
        const Color.fromARGB(255, 255, 210, 150),
      );
      // print(e.toString());
    }
  }

  Future<void> signOut(context) async {
    try {
      return await _auth.signOut();
    } catch (e) {
       openSnackBar(
        context,
        e.toString(),
        const Color.fromARGB(255, 255, 210, 150),
      );
      // print(e.toString());
    }
  }
}
