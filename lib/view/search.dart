import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/view/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  late QuerySnapshot _searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
   // intially searchController me koi value nahi hogi to error ko avoid krne ke liye -> 
    if (_searchController.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }

    await _databaseMethods
        .getUserbyUsername(_searchController.text.toString())
        .then((value) {
      // print("hello baby");
      _searchResultSnapshot = value;
      // print("your value is le bhai $value");
      // print(_searchResultSnapshot.docs.length);

      setState(() {
        isLoading = false;
        // haveUserSearched = true;
      });
    });
  }

  createChatroomAndStartConversation(String userName) {
    // print("${Constants.myName}");
    // banda khud ko messeage send nahi kar paye
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(Constants.myName!, userName);
      List<String?> users = [Constants.myName, userName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      _databaseMethods.createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreeen(
            chatRoomId: chatRoomId,
            username: userName,
          ),
        ),
      );
    } else {
      // print("you cann't send message to yourself");
    }
  }

  Widget SearchTile(String userName, String userEmail) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              ),
            ],
          ),
          const Spacer(),
          // use mainaxis accordingly  space
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 152, 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Message',
                style: simpleTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context) as PreferredSizeWidget,
      body: Column(
        children: [
          Container(
            color: const Color(0x54FFFFFF),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        haveUserSearched = true;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search username...',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // initiateSearch();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(colors: [
                        Color(0x36FFFFFF),
                        Color(0x0FFFFFFF),
                      ]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/images/search_white.png',
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // (_searchResultSnapshot.docs.length == 0)
          //     ? Center(
          //         child: CircularProgressIndicator(
          //         color: Colors.orange.shade600,
          //       ))
          //     :
          (isLoading)
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange.shade700,
                      color: Colors.amber.shade200,
                    ),
                  ),
                )
              : Expanded(
                  child: (haveUserSearched)
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResultSnapshot.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            String name =
                                _searchResultSnapshot.docs[index]["name"];
                            if (name.toLowerCase().contains(
                                _searchController.text.toLowerCase())) {
                              return SingleChildScrollView(
                                child: SearchTile(
                                  _searchResultSnapshot.docs[index]["name"],
                                  _searchResultSnapshot.docs[index]["email"],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResultSnapshot.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                              child: SearchTile(
                                _searchResultSnapshot.docs[index]["name"],
                                _searchResultSnapshot.docs[index]["email"],
                              ),
                            );
                          },
                        )),
        ],
      ),
    );
  }
}


