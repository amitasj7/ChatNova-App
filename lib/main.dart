import 'package:chat_app/Model/provider.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/google_sign_up.dart';

import 'package:chat_app/view/chatRoomScreen.dart';

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

  Future<void> getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      // print("your value ********************* $value");
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(create: (context) => passwordshow()),
      ],
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
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
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: const Color.fromARGB(255, 237, 180, 99),
            primaryColor: const Color.fromARGB(255, 253, 182, 96),
          ),
          home: (userIsLoggedIn != null)
              ? userIsLoggedIn!
                  ? const ChatRoom()
                  : const Authenticate()
              : const Center(child: Authenticate()),
        );
      }),
    );
  }
}
