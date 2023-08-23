import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreeen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreeen({required this.chatRoomId});

  @override
  State<ConversationScreeen> createState() => _ConversationScreeenState();
}

class _ConversationScreeenState extends State<ConversationScreeen> {
  var _messageController = TextEditingController();

  DatabaseMethods _databaseMethods = DatabaseMethods();

  late Stream chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index].data()["message"],
                        isSendByMe: (Constants.myName ==
                            snapshot.data.docs[index].data()["sendBy"]));
                  },
                )
              : Container();
        });
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> _messageMap = {
        "message": _messageController.text,
        "sendBy": Constants.myName!,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      _databaseMethods.addConversationMessage(widget.chatRoomId, _messageMap);
      setState(() {
        _messageController.text = "";
      });
    } else {
      print("hey baby");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _databaseMethods.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context) as PreferredSizeWidget,
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'Charm',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message... ',
                          hintStyle: TextStyle(color: Colors.white54,fontFamily: 'Charm'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset('assets/images/send.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({required this.message, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,
      // height:MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 20, right: isSendByMe ? 20 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.bottomRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        margin: isSendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(
                right: 30,
              ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          // color: Colors.green.shade400,
          gradient: LinearGradient(
            colors: isSendByMe
                ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC),
                  ]
                : [
                    const Color(0x1AFFFFFF),
                    const Color(0x1AFFFFFF),
                  ],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontFamily: 'Charm',
            // fontWeight: FontWeight.bold,




          ),
        ),
      ),
    );
  }
}
