import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    // backgroundColor: Color.fromARGB(219, 168, 122, 201),
    title: Image.asset(
      "assets/images/chat_nova1.png",
      height: 50,
    ),
    elevation: 0.0,
    centerTitle: false,
    // centerTitle also false by default.
  );
}

InputDecoration textFieldInputDecoration(String _hintText,) {
  return InputDecoration(
    
    hintText: _hintText,
    hintStyle: const TextStyle(
      color: Colors.black45,
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black45,
      ),
    ),
    disabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}

TextStyle simpleTextStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 18,
  );
}
