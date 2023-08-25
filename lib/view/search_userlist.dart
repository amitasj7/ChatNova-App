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
  var _searchController = TextEditingController();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  late QuerySnapshot _searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }

    await _databaseMethods
        .getUserbyUsername(_searchController.text.toString())
        .then((value) {
      print("hello baby");
      _searchResultSnapshot = value;
      print(_searchResultSnapshot);

      setState(() {
        isLoading = false;
        haveUserSearched = true;
      });
    });
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _searchResultSnapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return SearchTile(
                _searchResultSnapshot.docs[index]["name"],
                _searchResultSnapshot.docs[index]["email"],
              );
            },
          )
        : Container();
  }

  createChatroomAndStartConversation(String userName) {
    print("${Constants.myName}");
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
      print("you cann't send message to yourself");
    }
  }

  Widget SearchTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail!,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          // use mainaxis accordingly  space
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Text(
                'Message',
                style: simpleTextStyle(),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 152, 2),
                borderRadius: BorderRadius.circular(30),
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
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    color: Color(0x54FFFFFF),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value){  
                              setState(() {
                                
                              });
                            },
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search username...',
                              hintStyle: TextStyle(color: Colors.black45),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   late final String? userName;
//   late final String? userEmail;
//
//   SearchTile({this.userName, this.userEmail});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 24,
//         vertical: 18,
//       ),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userName!,
//                 style: simpleTextStyle(),
//               ),
//               Text(
//                 userEmail!,
//                 style: simpleTextStyle(),
//               ),
//             ],
//           ),
//           Spacer(),
//           // use mainaxis accordingly  space
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 10,
//             ),
//             child: Text(
//               'Message',
//               style: simpleTextStyle(),
//             ),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade400,
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
