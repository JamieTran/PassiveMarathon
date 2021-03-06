// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import '../profile_pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/group_pages/add_member.dart';
import 'package:passive_marathon/group_pages/results_page.dart';
import '../constants.dart' as Constants;
import './group_options.dart';
import '../mrthn/mrth_api.dart';
import 'package:flutter/scheduler.dart';

class GroupScreen extends StatefulWidget {
  var groupData;

  @override
  GroupPage createState() => GroupPage(groupData);

  GroupScreen(this.groupData);
}

class GroupPage extends State<GroupScreen> {
  var groupData;
  bool isAdmin = false;

  GroupPage(this.groupData);

  @override
  void initState() {
    super.initState();
    //updateUI();   // This code will call checkRaceComplete once the very last frame is rendered to the screen
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => checkRaceComplete(context));
    }
    updateDistance();
  }

  checkRaceComplete(context) {
    print(membersInRace.toString());
    if (membersInRace > 3) {
      print('Over 3 memebrs');
      if (winnersList.length == 3) // 3 winners found, end race
      {
        winnersList.clear();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultsScreen(groupData, winnersList)));
      }
    } else {
      print('less than 3 members');
      if (winnersList.length == 1) // 1 winner found, end race
      {
        winnersList.clear();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultsScreen(groupData, winnersList)));
      }
    }
  }

  updateDistance() async {
    var startDate;
    Map<String, String> userIDs = new Map<String, String>();
    await Constants.dbManagement
        .getGroupRef(groupData)
        .get()
        .then((datasnapshot) async {
      if (datasnapshot.exists) {
        startDate = datasnapshot.data['startDate'];
        print(startDate);
        List<dynamic> members = datasnapshot.data['membersInfo'];
        for (var member in members) {
          await Constants.dbManagement
              .getIDFromCode(member['reference'])
              .then((user) => {
                    userIDs.addAll({member['reference']: user})
                  });
        }
      }
    });
    print(startDate);

    // get each distance from mrthn
    // userIDs.forEach((k,v) => {
    //   MrthnAPI.fetchDistance(v,startDate).then((distance) => {
    //     Constants.dbManagement.updateDistance(k, double.parse(distance), groupData),
    //     })
    // });}
  }

  sortMembers(dynamic unorderedList) {
    List<dynamic> membersList = unorderedList;

    membersList.sort((m1, m2) {
      var r = m2["distance"].compareTo(m1["distance"]);
      if (r != 0) return r;
      return m2["distance"].compareTo(m1["distance"]);
    });

    return membersList;
  }

  updateUI() {
    Constants.dbManagement.getGroupRef(groupData).get().then((datasnapshot) {
      if (datasnapshot.exists) {
        String adminRef = datasnapshot.data['admin'];

        if (adminRef == Constants.dbManagement.getUserRef()) // User is Admin
        {
          setState(() {
            isAdmin = true;
          });
        } else // User is not Admin
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
    switch (choice.title) {
      case "Restart":
        showAlertDialog(context, groupData, Constants.restart_group);
        break;
      case "Invite Member":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddMember(groupData)));
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

  AppBar checkRole() {
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
          ]);
    } else // User is not Admin
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
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: checkRole(),
        backgroundColor: Constants.bright_white,
        body: Column(children: [
          Expanded(
              child: StreamBuilder(
            stream: Constants.dbManagement.getGroupStreamSnapShot(groupData),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              List<dynamic> sortedList =
                  sortMembers(snapshot.data["membersInfo"]);
              membersInRace = sortedList.length;
              return ListView.builder(
                shrinkWrap: true,
                itemExtent: 80.0,
                itemCount: sortedList.length,
                itemBuilder: (context, index) => _buildListItem(
                    context,
                    sortedList[index],
                    snapshot.data["groupDistance"],
                    index,
                    groupData), //snapshot.data.documents[index]
              );
            },
          ))
        ]));
  }
}

List<String> winnersList = new List<String>();
var membersInRace = 0;

showAlertDialog(BuildContext context, groupName, int feature) {
  // set up the buttons
  switch (feature) {
    // Delete the group option
    case Constants.delete_group:
      {
        Widget cancelButton = FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
          },
        );
        Widget continueButton = FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
            Constants.dbManagement.deleteGroup(groupName); // Delete Group Here
            Navigator.of(context).pop(); // return to previous screen
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("Delete Group"),
          content: Text(
              "This following action will delete this group, do you wish to continue?"),
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
    case Constants.exit_group:
      {
        Widget cancelButton = FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
          },
        );
        Widget continueButton = FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog

            try {
              // Leave Group Here, null = current user leaves
              Constants.dbManagement.leaveGroup(groupName, null);
            } catch (e) {
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

Widget _buildListItem(
    BuildContext context, document, groupDistance, indexVal, groupData) {
  return ListTile(
    title: Row(
      children: [
        Expanded(
            child: Container(
          color: determineBackgroundColor(indexVal),
          child: determineRaceStatus(
              document, groupDistance, indexVal, context, groupData),
        ))
      ],
    ),
    onTap: () async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new ProfilePage(document['reference'])));
    },
  );
}

ListTile determineRaceStatus(
    document, groupDistance, indexVal, BuildContext context, groupData) {
  var userDistance = document['distance'];

  if (userDistance >= groupDistance) // Race Complete
  {
    if (!winnersList.contains(document['name'])) // If list doesnt have winner,
    {
      winnersList.add(document['name']); // Add winner
    }
  }

  return _tile(document["name"].toString(), groupDistance, userDistance,
      Icons.account_circle, indexVal);
}

ListTile _tile(
        String title, groupDistance, userDistance, IconData icon, indexVal) =>
    ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: LinearProgressIndicator(
        value: (userDistance / groupDistance),
        valueColor: displayFinishColors(groupDistance, userDistance),
        backgroundColor: Constants.bright_white,
      ),
      leading: Icon(
        icon,
        color: Constants.placement_colors[indexVal],
        size: 50,
      ),
      trailing: Text(userDistance.toString() + ' Km'),
    );

displayFinishColors(distance, distanceComplete) {
  if (distanceComplete >= distance) {
    return new AlwaysStoppedAnimation<Color>(
        Colors.yellow[200]); // Race completed Color
  } else {
    return new AlwaysStoppedAnimation<Color>(
        Colors.blue[300]); // Race in progress Color
  }
}

determinePosition(place) {
  switch (place) {
    case 0:
      return Icon(Icons.flag, color: Colors.black, size: 25);
      break;
    default:
      return null;
      break;
  }
}

determineBackgroundColor(place) {
  switch (place) {
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

determineColor(place) {
  switch (place) {
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
