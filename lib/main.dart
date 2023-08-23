import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/view/google_sign_up.dart';
import 'package:chat_app/view/homepage.dart';
import 'package:chat_app/view/sign_In_page.dart';
import 'package:chat_app/view/sign_UP_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool? userIsLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          title: 'ChatNova',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            fontFamily: 'overpass',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            primaryColor: Color(0xff145C9E),
          ),
          home: (userIsLoggedIn != null)
              ? userIsLoggedIn!
                  ? ChatRoom()
                  : Authenticate()
              : Container(
                  child: Center(child: Authenticate()),
                )),
    );
  }
}
