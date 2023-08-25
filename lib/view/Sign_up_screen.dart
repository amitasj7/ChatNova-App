import 'package:chat_app/Model/provider.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/google_sign_up.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/chatRoomScreen.dart';

import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUPScreen extends StatefulWidget {
  final Function? toggle;

  SignUPScreen({required this.toggle});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  HelperFunctions _helperFunctions = HelperFunctions();
  DatabaseMethods _databaseMethods = DatabaseMethods();
  AuthMethods _authMethods = AuthMethods();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // kisi variable ko final and var dono se ek sath declare nahi kar skte

  signMeUP() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameController.text.toString(),
        "email": emailController.text.toString(),
      };
      HelperFunctions.saveUserEmailSharedPreference(
          emailController.text.toString());
      HelperFunctions.saveUserNameSharedPreference(
          usernameController.text.toString());

      setState(() {
        isLoading = true;
      });
      _authMethods
          .signUpWithEmailAndPassword(
              emailController.text.toString(), passController.text.toString(),context)
          .then((value) {
        print("${value!.userId}");

        _databaseMethods.uploadUserInfo(userInfoMap,context);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            )
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.orange[900]!,
                Colors.orange[800]!,
                Colors.orange[400]!,
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    // color: Colors.teal,
                    width: MediaQuery.of(context).size.width * 0.30,

                    child: Image.asset("assets/images/chatnova_black.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "Sign UP",
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                        Text(
                          "Welcome",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            top: 60,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    // padding: EdgeInsets.all(,),

                                    decoration: BoxDecoration(
                                        // color: Colors.teal,
                                        color: Colors.white54,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(225, 95, 27, 3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          )
                                        ]),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade200))),
                                              child: TextFormField(
                                                controller: usernameController,
                                                cursorColor:
                                                    Colors.orange.shade900,
                                                decoration: InputDecoration(
                                                  prefixIcon: Container(
                                                      height: 5,
                                                      width: 5,
                                                      // color: Colors.red,
                                                      child: Center(
                                                          child: FaIcon(
                                                        FontAwesomeIcons.user,
                                                        color: Colors
                                                            .orange.shade700,
                                                      ))),
                                                  hintText: "Username",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                                //  textAlign: TextAlign.center,
                                              )),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade200))),
                                              child: TextFormField(
                                                controller: emailController,
                                                cursorColor:
                                                    Colors.orange.shade900,
                                                decoration: InputDecoration(
                                                  prefixIcon: Container(
                                                      height: 5,
                                                      width: 5,
                                                      // color: Colors.red,
                                                      child: Center(
                                                          child: FaIcon(
                                                        FontAwesomeIcons
                                                            .envelopeOpen,
                                                        color: Colors
                                                            .orange.shade700,
                                                      ))),
                                                  suffixText: "@gmail.com  ",
                                                  hintText: "Email",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                                //  textAlign: TextAlign.center,
                                              )),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: Consumer<passwordshow>(
                                                builder:
                                                    (context, value, child) {
                                              return TextFormField(
                                                controller: passController,
                                                validator: (temp) {
                                                  return (temp!.isEmpty ||
                                                          temp.length < 6)
                                                      ? "minimum 6 character required"
                                                      : null;
                                                },
                                                obscureText: !value.loading,
                                                // obscuretext ki value true hone par password show nahi hota hai
                                                cursorColor:
                                                    Colors.orange.shade900,
                                                decoration: InputDecoration(
                                                  suffixIcon: Container(
                                                    width: 8,
                                                    // height: 2,
                                                    // color: Colors.teal,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            value.setloading(
                                                                value.loading),
                                                        child: (value.loading)
                                                            ? FaIcon(
                                                                FontAwesomeIcons
                                                                    .eye,
                                                                color: Colors
                                                                    .orange
                                                                    .shade900,
                                                              )
                                                            : FaIcon(
                                                                FontAwesomeIcons
                                                                    .eyeSlash,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                      ),
                                                    ),
                                                  ),
                                                  prefixIcon: Container(
                                                      height: 5,
                                                      width: 5,
                                                      // color: Colors.red,
                                                      child: Center(
                                                          child: FaIcon(
                                                        FontAwesomeIcons.lock,
                                                        color: Colors
                                                            .orange.shade700,
                                                      ))),
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                              );
                                            }),

                                            //  textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => widget.toggle!(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Already have an account? ",
                                          style: TextStyle(
                                              color: Colors.grey.shade700)),
                                      Text("Login",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () => signMeUP(),
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 50,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.orange.shade900,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign UP",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Text("Continue with social media",
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.facebook,
                                            size: 40,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // return GoogleSignInProvider()
                                          //     .signInWithGoogle();
                                          final _provider =
                                              Provider.of<GoogleSignInProvider>(
                                                  context,
                                                  listen: false);
                                          _provider.googleLogin(context);

                                          
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white54,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Image.asset(
                                              "assets/images/Google_logo.png",
                                              fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.github,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
