import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import '../constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon

class InviteScreen extends StatefulWidget {
  @override 
    InviteManagement createState() => InviteManagement();
}

class InviteManagement extends State<InviteScreen> {
@override
void initState() {
  super.initState();
  updateList();
}

//ist<dynamic> friendsArray = new List<dynamic>();

List<String> friendsList = new List<String>();
var friendArray =[];

updateList()
{
  friendArray.clear();
  friendsList.clear();
  DatabaseManagement().getFriendsArray().get().then((datasnapshot) {
    if (datasnapshot.exists) {
      friendsList = List.from(datasnapshot.data['friends']);
      for (int i=0;i<friendsList.length;i++){
        setState((){
          friendArray.add(friendsList[i]);
          });      
        }
      print("OUTSIDE FUNCTION ->"+friendArray.toString());
    }
  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitations"),
        backgroundColor: Constants.bright_blue),
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
                  return buildResultCard(element, element,context, Constants.remove_friend, updateList);
                }).toList()),
            ],
          )
      );
  }
}


Widget buildResultCard(dataField, dataObject, context, feature, Function updateFunc) {
  return new GestureDetector(
  onTap: ()=> showAlertDialog(context, dataField, dataObject, feature, updateFunc),
  child: new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center (
          child: Text(dataField,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          )),
        )
      ),
    )
  );
}

showAlertDialog(BuildContext context, dataField, dataObject, int feature, Function updateFunc) {
  // set up the buttons
  switch (feature)
  {
    case Constants.add_friend: {
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.of(context).pop(); // dismiss dialog
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Confirm"),
        onPressed:  () {
          Navigator.of(context).pop(); // dismiss dialog
          DatabaseManagement().addFriend(dataObject['name']);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Add Friend"),
        content: Text("Would you like to add "+dataField+" as your friend?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
        }
    break;
  case Constants.remove_friend: {
    Widget cancelButton = FlatButton(
            child: Text("Cancel"),
            onPressed:  () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          );
          Widget continueButton = FlatButton(
            child: Text("Confirm"),
            onPressed:  () async {
              Navigator.of(context).pop(); // dismiss dialog
              DatabaseManagement().removeFriend(dataObject);
              if (updateFunc != null)
              {
                updateFunc();
              }
                // The content doesn't update when you remove it. This is because when we click on a user in the friend
                // list, it will open a new page, when we return from that page, thats when we can refresh this.
                // This is similar to how the list is refreshed when we add a friend.
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text("Remove Friend"),
            content: Text("Would you like to remove "+dataField+" from your friend list?"),
            actions: [
              cancelButton,
              continueButton,
            ],
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
    }
    break;
}
}