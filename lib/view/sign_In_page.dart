import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/view/forget_password_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final Function? toggle;

  SignIn({required this.toggle});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  AuthMethods _authMethods = AuthMethods();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot? userInfoSnapshot;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      HelperFunctions.saveUserEmailSharedPreference(
          emailController.text.toString());

      _authMethods
          .signInWithEmailAndPassword(
              emailController.text.toString(), passController.text.toString())
          .then((value) async {
        if (value != null) {
          userInfoSnapshot =
              await _databaseMethods.getUserbyUserEmail(emailController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot!.docs[0]["name"]);

          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot!.docs[0]["email"]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }).catchError((e) {
        print("Incorrect information , please fill again");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context) as PreferredSizeWidget,
      body: (isLoading)
          ? Container(
              child: const Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 150,
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: textFieldInputDecoration('Email'),
                                  style: simpleTextStyle(),
                                  validator: (value) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!)
                                        ? null
                                        : "Enter correct email";
                                  },

                                  // decoration: InputDecoration(
                                  //   hintText: 'Email',
                                  //   hintStyle: TextStyle(
                                  //     color: Colors.white54,
                                  //   ),
                                  //   focusedBorder: OutlineInputBorder(
                                  //     borderSide: BorderSide(color: Colors.white54,),
                                  //   ),
                                  //   enabledBorder: OutlineInputBorder(
                                  //     borderSide: BorderSide(color: Colors.white54,),
                                  //   )
                                  // ),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  controller: passController,
                                  decoration:
                                      textFieldInputDecoration("Password"),
                                  style: simpleTextStyle(),
                                  validator: (value) {
                                    return (value!.length < 6)
                                        ? "At least 6 char required"
                                        : null;
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.centerRight,
                          // 1st Container ke andar jo bhi likha jaiga vo centerRight me hi jaiga. so 2 Container par ye lagu hoga.
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              // color: Colors.teal,
                              child: Text(
                                'Forgot Password ?',
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              gradient: const LinearGradient(colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC),
                              ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Sign In",
                              // style: TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 18,
                              // ),
                              style: mediumTextStyle(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal : 50,vertical: 12),
                                  child: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                                  // FaIcon class se koi bhi google etc ka icon catch kar skte hai
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     left: 20,
                                //     right: 20,
                                //   ),
                                //   child: CircleAvatar(
                                //     radius: 30,
                                //     backgroundImage: AssetImage(
                                //         "assets/images/google_image.jpg"),
                                //     backgroundColor: Colors.orange,
                                //   ),
                                // ),

                                Text(
                                  "Sign In with Google",
                                  // style: TextStyle(
                                  //   color: Colors.white,
                                  //   fontSize: 18,
                                  // ),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account? ",
                              style: mediumTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle!();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: const Text('Register Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
