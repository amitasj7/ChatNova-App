import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/account_details.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/view/google_sign_up.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUP extends StatefulWidget {
  final Function? toggle;

  SignUP({required this.toggle});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
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
              emailController.text.toString(), passController.text.toString())
          .then((value) {
        print("${value!.userId}");

        _databaseMethods.uploadUserInfo(userInfoMap);
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
      appBar: appBarMain(context) as PreferredSizeWidget,
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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
                                controller: usernameController,
                                decoration:
                                    textFieldInputDecoration("Username"),
                                style: simpleTextStyle(),
                                validator: (value) {
                                  return (value!.isEmpty || value.length < 4)
                                      ? "Usename char 4+ provide"
                                      : null;
                                },
                              ),
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
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            signMeUP();
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
                              "Sign UP",
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
                          onTap: () {
                            final _provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            _provider.googleLogin();

                          },
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
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        "assets/images/google_image.jpg"),
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text(
                                  "Sign UP with Google",
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
                              "Already have account? ",
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
                                child: const Text('Sign IN Now',
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
