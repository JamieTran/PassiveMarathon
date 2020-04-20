// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import 'package:passive_marathon/group_pages/add_member.dart';
import '../constants.dart' as Constants;
import './group_options.dart';

class ResultsScreen extends StatefulWidget {

  var groupData;

  @override 
    ResultsPage createState() => ResultsPage(groupData);

    ResultsScreen(this.groupData);
}

class ResultsPage extends State<ResultsScreen> {

  var groupData;
  bool isAdmin=false;

  ResultsPage(this.groupData);

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

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    switch (choice.title)
    {
      case "Restart":
        showAlertDialog(context, groupData, Constants.restart_group);
        break;
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
                title: Text("Results"),
                backgroundColor: Constants.bright_red,
                actions: <Widget>[
                  PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return adminMarathonComplete.map((Choice choice) {
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
                title: Text("Results"),
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
        null
      );
  }
}

showAlertDialog(BuildContext context, groupName, int feature) {
  // set up the buttons
  switch (feature)
  {
    case Constants.restart_group: {   
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
          Constants.dbManagement.restartGroup(groupName);
          Navigator.of(context).pop();                 // return to previous screen
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Restart Marathon"),
        content: Text("This following action will restart the marathon, do you wish to continue?"),
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