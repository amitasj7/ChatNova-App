import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/sign_UP_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/authenticate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return AccountDetails();
        } else if (snapshot.hasError) {
          return Center(child: Text("Something went Wrong"));
        } else {
          return Authenticate();
        }
      },
    ));
  }
}
