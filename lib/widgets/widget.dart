import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Color.fromARGB(219, 168, 122, 201),
    title: Image.asset(
      "assets/images/chat_nova1.png",
      height: 50,
    ),
    elevation: 0.0,
    centerTitle: false,
    // centerTitle also false by default.
  );
}

InputDecoration textFieldInputDecoration(String _hintText) {
  return InputDecoration(
      hintText: _hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white54,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white54,
        ),
      ));
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}
