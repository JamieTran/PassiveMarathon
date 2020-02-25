import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import '../constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon

class FriendScreen extends StatefulWidget {
  @override 
    FriendsManagement createState() => FriendsManagement();
}

class FriendsManagement extends State<FriendScreen> {

@override
void initState() {
  super.initState();
  //updateList();
}

List<dynamic> friendsArray = new List<dynamic>();

updateList()
{
  friendsArray = DatabaseManagement().getFriends();
  print("OUTSIDE FUNCTION --->" + friendsArray.toString());
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        backgroundColor: Constants.bright_blue,
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendAdd())
            ); 
              },
            ),
        ]),
      backgroundColor: Constants.bright_white,
      body: Center(
//        child:ListView.builder(
//        //itemCount: friendsArray.length,
//        itemBuilder: (context, index) {
//          return ListTile(
//           title: Text(friendsArray[index]),
//          );
//        },
//      ),
      ),
    );
  }
}