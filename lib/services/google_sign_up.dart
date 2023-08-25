import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/view/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/services/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin(context) async {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountDetails(),
        ),
      );
    } catch (e) {
      openSnackBar(
        context,
        e.toString(),
        Color.fromARGB(255, 255, 210, 150),
      );
      print(e.toString());
    }

    notifyListeners();
  }

  // signInWithGoogle() async {
  //   // begin interactive sign in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  //   // obtain auth details from request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  //   // create a new credential for user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );

  //   // finally , lets sign in
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  logout() async {
    // clear data from sharedpreferences
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    print(
        "Hello World bhai ${await HelperFunctions.getUserLoggedInSharedPreference()}");

    print("hello world 2");
    // firebase se signout
    FirebaseAuth.instance.signOut();
    print("hello world 3");
    // google sign se disconnect
    await _googleSignIn.disconnect();
  }
}
