import 'package:flutter/material.dart';

void openSnackBar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // elevation: 3,
    // behavior: SnackBarBehavior.floating,
    // backgroundColor: Color.fromARGB(0, 241, 161, 69),
    backgroundColor:
        color, // background color se match krna padega tabhi transparent banegaa
    content: Container(
      // padding: EdgeInsets.all(8),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.error, size: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(snackMessage,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.fade),
            ),
          ),
        ],
      ),
    ),
    // action: SnackBarAction(
    //   label: "!",
    //   textColor: Colors.red,
    //   onPressed: () {},
    // ),
  ));
}
