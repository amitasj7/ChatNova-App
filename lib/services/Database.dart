import 'package:chat_app/helper/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    // print("in getuserbyusername");
    return await FirebaseFirestore.instance
        .collection("users")
        // .where("name", isEqualTo: username)
        .get();
  }

  getUserbyUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get()
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      // print(e.toString());
    });
  }

  uploadUserInfo(userMap, context) {
    // ignore: body_might_complete_normally_catch_error
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      openSnackBar(
        context,
        e.toString(),
        const Color.fromARGB(255, 255, 210, 150),
      );
      // print(e.toString());
    });
  }

  createChatRoom(String chatRoomid, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomid)
        .set(chatRoomMap)
        .catchError((e) {
      // print(e.toString());
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      // print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
