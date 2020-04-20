import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import './create_group.dart';
import '../db_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class GroupsScreen extends StatefulWidget {
  @override 
    MarathonGroups createState() => MarathonGroups();
}

class MarathonGroups extends State<GroupsScreen> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marathon Groups"),
        backgroundColor: Constants.bright_red,
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CreateGroup();
                  });
              },
            ),
        ],
      ),
      backgroundColor: Constants.bright_white,
      body: 
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(Constants.dbManagement.getUserRef()).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)
          {
            if (snapshot.hasError) {
              return Text ('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState)
            {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (_, int index) {
                    String groupName = snapshot.data['groups'].elementAt(index);
                      return buildGroupRedirectCard(groupName, _);
                  }
                );     
            }
          },
        )
    );
  }
  
  void onItemMenuPress(String choice, BuildContext context) {
    if (choice == Constants.create_group) {
      showDialog(
        context: context,
        builder: (context) {
          return CreateGroup();
        });
    } else if (choice == Constants.add_group) {
      print('Add Group page here');
    } else if (choice == Constants.leave_group) {
      print('Leave Group page here');
    }
  }
}