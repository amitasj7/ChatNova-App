import 'dart:io';

import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:chat_app/services/Database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ConversationScreeen extends StatefulWidget {
  final String chatRoomId;
  String? username;

  ConversationScreeen({super.key, required this.chatRoomId, this.username});

  @override
  State<ConversationScreeen> createState() => _ConversationScreeenState();
}

class _ConversationScreeenState extends State<ConversationScreeen> {
  String _imageURL = "";
  final _messageController = TextEditingController();

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  late Stream chatMessageStream;

  Widget ChatMessageList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      // print(
                      //     "your data here : ${snapshot.data.docs[index].data().containsKey("image")}");

                      return (snapshot.data.docs[index]
                              .data()
                              .containsKey("image"))
                          ? ImageTile(
                              image: snapshot.data.docs[index].data()["image"],
                              isSendByYou: (Constants.myName ==
                                  snapshot.data.docs[index].data()["sendBy"]))
                          : MessageTile(
                              message:
                                  snapshot.data.docs[index].data()["message"],
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
        "time": DateTime.now().millisecondsSinceEpoch,
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

  imageuploadonchatroomid() {
    if (_imageURL.isNotEmpty) {
      Map<String, dynamic> _messageMap2 = {
        "image": _imageURL,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      _databaseMethods.addConversationMessage(widget.chatRoomId, _messageMap2);
      setState(() {
        // print("successfully added imageURL in chatroomid");
        _imageURL = "";
      });
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
      // backgroundColor: Color.fromARGB(255, 255, 203, 175),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 158, 45),
        leading: const Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Icon(Icons.account_circle_rounded),
        ),
        title: TextButton(
            onPressed: () {},
            child: Text(
              widget.username ?? "",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
            // color: Colors.red,
            ),
        child: SingleChildScrollView(
          // keyword aane ke scroll krne ke liye
          child: Column(
            children: [
              SingleChildScrollView(
                  // chat scrollable ban jaye
                  child: Expanded(child: ChatMessageList())),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontFamily: 'Charm',
                                  ),
                                  cursorColor: Colors.black,
                                  // cursorHeight: 25,
                                  // cursorWidth: 3,
                                  decoration: const InputDecoration(
                                    hintText: 'Message... ',
                                    hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: 'Charm'),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    /*  
                                    1. pick image (install image_picker package)
                                    2. Upload the image to Firebase storage
                                    3. Get the URL of the Uploaded Image
                                    4. Store the Image URL inside the corresponding document of the database.
                                    5. Display the image on the list
                                    */

                                    /*  
                                    Step 1: Pick image
                                    
                                    */
                                    ImagePicker _imagePicker = ImagePicker();
                                    XFile? file = await _imagePicker.pickImage(
                                        source: ImageSource.gallery);

                                    // print("your file path here ${file?.path}");

                                    // step 2:
                                    if (file == null) return;

                                    String _uniqueFileName = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                    // get a reference to storage root
                                    Reference _referenceRoot =
                                        FirebaseStorage.instance.ref();
                                    Reference _referenceDirImages =
                                        _referenceRoot.child('images');

                                    // Create a reference for the image to be stored
                                    Reference _referenceImageToUpload =
                                        _referenceDirImages
                                            .child(_uniqueFileName);

                                    // Handle Errors/success
                                    try {
                                      // Store the file
                                      await _referenceImageToUpload
                                          .putFile(File(file.path));

                                      // Success: get the download URL
                                      _imageURL = await _referenceImageToUpload
                                          .getDownloadURL();

                                      // print("your imageurl is : $_imageURL");

                                      imageuploadonchatroomid();
                                    } catch (error) {
                                      openSnackBar(
                                        context,
                                        error.toString(),
                                        const Color.fromARGB(
                                            255, 255, 210, 150),
                                      );
                                    }
                                  },
                                  icon:
                                      const FaIcon(FontAwesomeIcons.paperclip))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange.shade800,
                            borderRadius: BorderRadius.circular(25)),
                        child: Image.asset(
                          'assets/images/send.png',
                          // fit: BoxFit.scaleDown,
                          // alignment: Alignment.center,
                          scale: 2.0,
                          // scale factor se size ko set kiya jata hai jitna kam scale factor hoga utna bda size hoga
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final String image;
  final bool isSendByYou;
  const ImageTile({super.key, required this.image, required this.isSendByYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,
      // height:MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.only(
          left: isSendByYou ? 0 : 20, right: isSendByYou ? 20 : 0),
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByYou ? Alignment.bottomRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        height: MediaQuery.of(context).size.height * 0.30,
        margin: isSendByYou
            ? const EdgeInsets.only(left: 20)
            : const EdgeInsets.only(
                right: 20,
              ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // decoration: BoxDecoration(
        // color: Colors.green.shade400,
        // color: Colors.teal,

        //   borderRadius: isSendByYou
        //       ? BorderRadius.only(
        //           topLeft: Radius.circular(23),
        //           topRight: Radius.circular(23),
        //           bottomLeft: Radius.circular(23),
        //         )
        //       : BorderRadius.only(
        //           topLeft: Radius.circular(23),
        //           topRight: Radius.circular(23),
        //           bottomRight: Radius.circular(23),
        //         ),
        // ),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          // scale: 3,
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByYou;

  const MessageTile(
      {super.key, required this.message, required this.isSendByYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,
      // height:MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.only(
          left: isSendByYou ? 0 : 20, right: isSendByYou ? 20 : 0),
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByYou ? Alignment.bottomRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.47,
        margin: isSendByYou
            ? const EdgeInsets.only(left: 20)
            : const EdgeInsets.only(
                right: 20,
              ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // color: Colors.green.shade400,
          gradient: LinearGradient(
              colors: isSendByYou
                  ? [
                      const Color(0xffFFBF00),
                      const Color.fromARGB(255, 231, 163, 96),
                      const Color(0xffFDA50F),
                    ]
                  : [
                      const Color.fromARGB(255, 224, 152, 26),
                      const Color.fromARGB(255, 219, 132, 85),
                      const Color(0xffFD6A02),
                    ]),
          borderRadius: isSendByYou
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: const TextStyle(
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
