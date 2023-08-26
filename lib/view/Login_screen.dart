import 'package:chat_app/Model/provider.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/chatRoomScreen.dart';
import 'package:chat_app/view/forget_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggle;

  const LoginScreen({super.key, required this.toggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  final AuthMethods _authMethods = AuthMethods();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot? userInfoSnapshot;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        HelperFunctions.saveUserEmailSharedPreference(
            emailController.text.toString());

        _authMethods
            .signInWithEmailAndPassword(emailController.text.toString(),
                passController.text.toString(), context)
            .then((value) async {
          if (value != null) {
            userInfoSnapshot =
                await _databaseMethods.getUserbyUserEmail(emailController.text);

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot!.docs[0]["name"]);

            HelperFunctions.saveUserEmailSharedPreference(
                userInfoSnapshot!.docs[0]["email"]);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatRoom(),
              ),
            );
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }).catchError((e) {
          openSnackBar(
            context,
            e.toString(),
            const Color.fromARGB(255, 255, 210, 150),
          );
          // print("Incorrect information , please fill again");
        });
      } catch (e) {
        openSnackBar(
          context,
          e.toString(),
          const Color.fromARGB(255, 255, 210, 150),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
            child: CircularProgressIndicator(color: Colors.orange),
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
                  SizedBox(
                    // color: Colors.teal,
                    width: MediaQuery.of(context).size.width * 0.30,

                    child: Image.asset("assets/images/chatnova_black.png"),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
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
                                        boxShadow: const [
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
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color:
                                                              Colors.white54))),
                                              child: TextFormField(
                                                onChanged: (value) {},
                                                controller: emailController,
                                                cursorColor:
                                                    Colors.orange.shade900,
                                                decoration: InputDecoration(
                                                  prefixIcon: SizedBox(
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
                                                  suffixText: (emailController
                                                              .text.isEmpty)
                                                      ? "@gmail.com  "
                                                      : "",
                                                  hintText: "Email",
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                                //  textAlign: TextAlign.center,
                                              )),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.white54))),
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
                                                  suffixIcon: SizedBox(
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
                                                  prefixIcon: SizedBox(
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
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                              );
                                            }),

                                            //  textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ForgetPasswordScreen();
                                    }));
                                  },
                                  child: const Text("Forgot Password?",
                                      style: TextStyle(color: Colors.black87)),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => signIn(),
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.orange.shade900,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                                GestureDetector(
                                  onTap: () => widget.toggle!(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account? ",
                                          style: TextStyle(
                                              color: Colors.grey.shade700)),
                                      Text("Create",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.orange.shade900)),
                                    ],
                                  ),
                                ),
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
