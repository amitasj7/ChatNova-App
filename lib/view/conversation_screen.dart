import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreeen extends StatefulWidget {
  final String chatRoomId;
  String? username;

  ConversationScreeen({required this.chatRoomId, this.username});

  @override
  State<ConversationScreeen> createState() => _ConversationScreeenState();
}

class _ConversationScreeenState extends State<ConversationScreeen> {
  var _messageController = TextEditingController();

  DatabaseMethods _databaseMethods = DatabaseMethods();

  late Stream chatMessageStream;

  Widget ChatMessageList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          message: snapshot.data.docs[index].data()["message"],
                          isSendByYou: (Constants.myName ==
                              snapshot.data.docs[index].data()["sendBy"]));
                    },
                  )
                : Container();
          }),
    );
  }

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> _messageMap = {
        "message": _messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      _databaseMethods.addConversationMessage(widget.chatRoomId, _messageMap);
      setState(() {
        _messageController.text = "";
      });
    }
    //  else {
    //   print("hey baby Nothing text available to send");
    // }
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
      // backgroundColor: Color.fromARGB(255, 255, 203, 175),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 158, 45),
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Icon(Icons.account_circle_rounded),
        ),
        title: TextButton(
            onPressed: () {},
            child: Text(
              widget.username ?? "",
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
      ),
      body: Container(
        decoration: BoxDecoration(
            // color: Colors.red,
            ),
        child: SingleChildScrollView(
          // keyword aane ke scroll krne ke liye
          child: Column(
            children: [
              SingleChildScrollView(
                  // chat scrollable ban jaye
                  child: Expanded(child: ChatMessageList())),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 251, 184, 83),
                    Color.fromARGB(255, 255, 164, 28),
                  ])),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontFamily: 'Charm',
                          ),
                          cursorColor: Colors.black,
                          // cursorHeight: 25,
                          // cursorWidth: 3,
                          decoration: InputDecoration(
                            hintText: 'Message... ',
                            hintStyle: TextStyle(
                                color: Colors.black45, fontFamily: 'Charm'),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Image.asset(
                          'assets/images/send.png',
                          // fit: BoxFit.scaleDown,
                          // alignment: Alignment.center,
                          scale: 2.0,
                          // scale factor se size ko set kiya jata hai jitna kam scale factor hoga utna bda size hoga
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByYou;

  MessageTile({required this.message, required this.isSendByYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,
      // height:MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.only(
          left: isSendByYou ? 0 : 20, right: isSendByYou ? 20 : 0),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByYou ? Alignment.bottomRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        margin: isSendByYou
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(
                right: 30,
              ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          // color: Colors.green.shade400,
          gradient: LinearGradient(
              colors: isSendByYou
                  ? [
                      const Color(0xffFFBF00),
                      Color.fromARGB(255, 231, 163, 96),
                      const Color(0xffFDA50F),
                    ]
                  : [
                      Color.fromARGB(255, 224, 152, 26),
                      Color.fromARGB(255, 219, 132, 85),
                      const Color(0xffFD6A02),
                    ]),
          borderRadius: isSendByYou
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
            color: Colors.black,
            fontSize: 21,
            fontFamily: 'Charm',
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
