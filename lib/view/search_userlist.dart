import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/Database.dart';
import 'package:chat_app/view/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchUserlistScreen extends StatefulWidget {
  const SearchUserlistScreen({super.key});

  @override
  State<SearchUserlistScreen> createState() => _SearchUserlistScreenState();
}

class _SearchUserlistScreenState extends State<SearchUserlistScreen> {
  final _searchController = TextEditingController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Stream? _searchStream;
  bool isLoading = false;
  bool haveUserSearched = false;


  initiateSearch() async {
    await _databaseMethods
        .getUserbyUsername(_searchController.text.toString())
        .then((value) {
      // print("hello baby");

      // print(_searchStream);
      setState(() {
        _searchStream = value;
      });
    }).catcherror((error) {
      // print("your stream error is : $error");
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

  // ignore: non_constant_identifier_names
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                          setState(() {});
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
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder(
                stream: _searchStream,
                builder: (BuildContext context, snapshot) {
                  // if snapshot data nahi rakhta hai to shimmer effect show
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                title: Container(
                                  height: 10,
                                  width: 90,
                                  color: Colors.white,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: 90,
                                  color: Colors.white,
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        String name = snapshot.data[index]["name"];

                        // for filter countries , we use this approch ->

                        if (_searchController.text.isEmpty) {
                          return SearchTile(
                            snapshot.data[index]["name"],
                            snapshot.data[index]["email"],
                          );
                        } else if (name.toLowerCase().contains(
                            _searchController.text.toLowerCase())) {
                          return SearchTile(
                            snapshot.data[index]["name"],
                            snapshot.data[index]["email"],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              )),
            ],
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
