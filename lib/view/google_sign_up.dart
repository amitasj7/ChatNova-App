import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/services/Database.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final _googleUser = await _googleSignIn.signIn();

      if (_googleUser == null) return;
      _user = _googleUser;

      final _googleAuth = await _googleUser.authentication;

      final _credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(_credential);
      HomePage();
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();

  }

  Future logout() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
