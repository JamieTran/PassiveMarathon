// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/group_pages/add_member.dart';
import '../constants.dart' as Constants;
import './group_options.dart';

class GroupScreen extends StatefulWidget {

  var groupData;

  @override 
    GroupPage createState() => GroupPage(groupData);

    GroupScreen(this.groupData);
}

class GroupPage extends State<GroupScreen> {

  var groupData;
  bool isAdmin=false;

  GroupPage(this.groupData);

@override
void initState() {
  super.initState();
  updateUI();
}

updateUI()
{
  Constants.dbManagement.getGroupRef(groupData).get().then((datasnapshot) {
    if (datasnapshot.exists) {
      String adminRef = datasnapshot.data['admin'];

        if (adminRef == Constants.dbManagement.getUserRef()) // User is Admin
        {
          setState(() {
            isAdmin = true;
          });
        }
        else  // User is not Admin
        {
          setState(() {
            isAdmin = false;        
          });
        } 
    }
  });
}

  Widget _buildListItem(BuildContext context, document, groupDistance, indexVal)
  {
    return ListTile(
      title: Row(
        children: [
          Expanded( child:
            Container(
              color: determineBackgroundColor(indexVal),
              child: 
                _tile(document["name"].toString(), (document["distance"]/groupDistance),document["distance"], Icons.account_circle, indexVal),
                )
              )
            ],
          ),
      onTap: () {
          // Profile Page redirect here
      },
    );
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    switch (choice.title)
    {
      case "Invite Member":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddMember(groupData))
          ); 
      break;
      case "Delete Group":
        // Show Warning Message
        showAlertDialog(context, groupData, Constants.delete_group);
      break;
      case "Leave Group":
        showAlertDialog(context, groupData, Constants.exit_group);
      break;
    }
  }

  AppBar checkRole()
  {
    if (isAdmin) // User is Admin
    {
      return AppBar(
                title: Text(groupData.toString()),
                backgroundColor: Constants.bright_red,
                actions: <Widget>[
                  PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return adminChoices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList();
                  },
                )
              ]
            );
    }
    else  // User is not Admin
    {
      return AppBar(
        title: Text(groupData.toString()),
        backgroundColor: Constants.bright_red,
        actions: <Widget>[
          PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return memberChoices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        )
      ]
    );
    }
  }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: checkRole(),
        backgroundColor: Constants.bright_white,
        body:
        Column(
          children :[
            Expanded( child: 
            StreamBuilder(
              stream: Constants.dbManagement.getGroupStreamSnapShot(groupData),
              builder:(context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 80.0,
                  itemCount: snapshot.data["membersInfo"].length,
                  itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data["membersInfo"][index], snapshot.data["groupDistance"], index), //snapshot.data.documents[index]
                );
              },
            )
            )
          ]
        )
      );
  }
}

showAlertDialog(BuildContext context, groupName, int feature) {
  // set up the buttons
  switch (feature)
  {
    // Delete the group option
    case Constants.delete_group: {   
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
          Constants.dbManagement.deleteGroup(groupName); // Delete Group Here
          Navigator.of(context).pop();                 // return to previous screen
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Group"),
        content: Text("This following action will delete this group, do you wish to continue?"),
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
        // Leave the group option
        case Constants.exit_group: {
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

          try {
          // Leave Group Here, null = current user leaves
          Constants.dbManagement.leaveGroup(groupName, null);
          }
          catch (e) {
            // May have to redo this, exception is thrown when leaving group
          }

          Navigator.of(context).pop(); // Leave group page
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Leave Group"),
        content: Text("Do you want to leave this group?"),
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

ListTile _tile(String title, distance, distanceComplete, IconData icon, indexVal) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: LinearProgressIndicator(
      value: distance,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[300]),
      backgroundColor: Constants.bright_white,
      ),
      leading: Icon(
        icon,
        color: Colors.black,
        size: 50,
      ),
      trailing: Text(distanceComplete.toString() + ' Km'),
    );

determinePosition(place)
{
  switch (place)
  {
    case 0:
      return Icon(Icons.flag, color: Colors.black, size:25);
    break;
    default:
      return null;
    break;
  }
}

determineBackgroundColor(place)
{
    switch (place)
  {
    case 0:
      return Constants.nautical_yellow;
    break;
    case 1:
      return Constants.place_second;
    break;
    case 2:
      return Constants.place_third;
    break;
    default:
      return Constants.bright_white;
    break;
  }
}

determineColor(place)
{
  switch (place)
  {
    case 0:
      return new AlwaysStoppedAnimation<Color>(Colors.yellow[200]);
    break;
    case 1:
      return new AlwaysStoppedAnimation<Color>(Colors.grey[300]);
    break;
    case 2:
      return new AlwaysStoppedAnimation<Color>(Colors.brown[300]);
    break;
    default:
      return new AlwaysStoppedAnimation<Color>(Colors.blue[300]);
    break;
  }
}