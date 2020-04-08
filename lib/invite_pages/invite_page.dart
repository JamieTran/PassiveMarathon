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

List<dynamic> invitesList = new List<dynamic>();
List<dynamic> outsideFunc = new List<dynamic>();
var invitesArray =[];

updateList()
{
  invitesArray.clear();
  invitesList.clear();
  DatabaseManagement().getInvitesArray().get().then((datasnapshot) {
    if (datasnapshot.exists) {
      setState((){
        invitesList = (datasnapshot.data['invites']);
      }); 
      print("List of Map Contains ->" +invitesList.toString());
        setState((){
          outsideFunc = invitesList;
          });      
        
      //print("OUTSIDE FUNCTION ->"+invitesArray.toString());
      print("OUTSIDE MAP ->"+outsideFunc.toString());
    }
  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitations"),
        backgroundColor: Constants.bright_blue),
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
                children: outsideFunc.map((element) {
                  print(element.toString());
                  return buildResultCard(element,context);
                }).toList()),
            ],
          )
      );
  }
}


Widget buildResultCard(data, context) {
  return new GestureDetector(
  onTap: ()=> showAlertDialog(context, data),
  child: new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(  
        child: Center (
          child: Text("Invite from " +data["senderName"],
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

showAlertDialog(BuildContext context, data) {
  // set up the buttons
  switch (data['type'])
  {
    case Constants.friend_request: {
      Widget cancelButton = FlatButton(
        child: Text("No"),
        onPressed:  () {
          Navigator.of(context).pop(); // dismiss dialog
          // Remove request from invites
          DatabaseManagement().removeInvite(data);
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed:  () {
          Navigator.of(context).pop(); // dismiss dialog
          // Add Friend
          DatabaseManagement().addFriend(data['senderName'],data['senderRef']);
          // Remove request from invites
          DatabaseManagement().removeInvite(data);

        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Friend Request"),
        content: Text("Would you like to add "+data["senderName"]+" as your friend?"),
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
  case Constants.group_request: {
    Widget cancelButton = FlatButton(
            child: Text("No"),
            onPressed:  () {
              Navigator.of(context).pop(); // dismiss dialog
              // Remove Request
              DatabaseManagement().removeInvite(data);
            },
          );
          Widget continueButton = FlatButton(
            child: Text("Yes"),
            onPressed:  () async {
              Navigator.of(context).pop(); // dismiss dialog
              // Add user to group and add the group to the users array
              DatabaseManagement().addUserToGroup(data["groupName"]); 
              // Remove Request
              DatabaseManagement().removeInvite(data);
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text("Join Group"),
            content: Text(data["senderName"] + " has invited you to join " + data["groupName"] + ", do you wish to accept?"),
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