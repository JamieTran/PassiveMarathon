import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import '../constants.dart' as Constants;
import 'friend_add_page.dart';

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
  updateList();
}

//ist<dynamic> friendsArray = new List<dynamic>();

//List<String> friendsList = new List<String>();
Map<String, String> friendsList = new Map<String, String>();
var friendArray =[];

updateList()
{
  friendArray.clear();
  friendsList.clear();
  DatabaseManagement().getFriendsArray().get().then((datasnapshot) {
    if (datasnapshot.exists) {
      friendsList = Map.from(datasnapshot.data['friends']);
      var list = friendsList.keys.toList();
      print(friendsList.toString());
      //setState(() {
/*         if (friendsList.isNotEmpty)
        {
          friendArray.add(friendsList.keys);
        }
      }); */
      for (int i=0;i<friendsList.length;i++){
        setState((){
          friendArray.add(list[i]);
          });      
        }
      print("OUTSIDE FUNCTION ->"+friendArray.toString());
    }
  });
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
              onPressed: () async {
              //String result = await Navigator.of(context).pushNamed('/friendadd');
               await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendAdd()));
                setState((){
                  updateList();
               }); 
              },
            ),
        ]),
      backgroundColor: Constants.bright_white,
      body:
        ListView(
          children: <Widget>[
            SizedBox(height:10.0),
            GridView.count(
              padding: EdgeInsets.only(left:10.0, right:10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary:false,
              shrinkWrap: true,
              children: friendArray.map((element) {
                return buildResultCard(element, element,null, context,Constants.remove_friend, updateList);
              }).toList()),
          ],
        )
    );
  }
}
