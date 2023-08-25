import 'package:chat_app/view/Login_screen.dart';
import 'package:chat_app/view/Sign_up_screen.dart';

import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toggle: toggleView,);
    } else {
      return SignUPScreen(toggle: toggleView);
    }
  }
}
