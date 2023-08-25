import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/services/google_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  DatabaseMethods _databaseMethods = DatabaseMethods();
  AuthMethods _authMethods = AuthMethods();

  signMeUP() {
    final _user1 = FirebaseAuth.instance.currentUser;
    var emailController = _user1!.email!;
    var firstusername = _user1.displayName;
    var usernameController = firstusername!.replaceAll(" ", "");
    Map<String, String> userInfoMap = {
      "name": usernameController,
      "email": emailController,
    };
    HelperFunctions.saveUserEmailSharedPreference(emailController);
    HelperFunctions.saveUserNameSharedPreference(usernameController);

    // _authMethods
    //     .signUpWithEmailAndPassword(emailController.text.toString(),
    //         passController.text.toString())
    //     .then((value) {
    //   print("${value!.userId}");
    //
    //
    // });

    _databaseMethods.uploadUserInfo(userInfoMap,context);
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatRoom(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;

    // _user again and again update hoga

    return Scaffold(
        appBar: AppBar(
          title: Text("Account Detail"),
          centerTitle: true,
          actions: [
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                final _provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                _provider.logout();
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  signMeUP();
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(_user!.photoURL!),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Name :  " + _user.displayName!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email :  " + _user.email!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}
