import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/conversation_screen.dart';
import 'package:chat_app/services/google_sign_up.dart';
import 'package:chat_app/view/search.dart';

import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods _authMethods = AuthMethods();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      userName: snapshot.data.docs[index]["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName!, ""),
                      chatRoomId: snapshot.data.docs[index]["chatroomId"],
                    );
                  })
              : Container();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    _databaseMethods.getChatRooms(Constants.myName!).then((value) {
      print("your value is ************* $value");
      setState(() {
        chatRoomsStream = value;
      });
    });

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/chat_nova1.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              GoogleSignInProvider().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Container(
        child: chatRoomList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreeen(
                  username: userName, chatRoomId: chatRoomId)),
        );
      },
      child: Container(
        // color: Colors.teal.shade400,
        // margin:
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.orange.shade800,
              width: 1,
            ),
          ),
        ),

        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
