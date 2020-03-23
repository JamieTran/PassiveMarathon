import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import '../constants.dart' as Constants;
import './create_group.dart';
import '../db_management.dart';

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class GroupsScreen extends StatefulWidget {
  @override 
    MarathonGroups createState() => MarathonGroups();
}

class MarathonGroups extends State<GroupsScreen> {

  @override
  void initState() {
  super.initState();
  updateList();
  }

List<String> groupsList = new List<String>();
var groupArray =[];

updateList()
{
  print("updateList called");
  groupArray.clear();
  groupsList.clear();
  DatabaseManagement().getGroupsArray().get().then((datasnapshot) {
    if (datasnapshot.exists) {
      groupsList = List.from(datasnapshot.data['groups']);
      for (int i=0;i<groupsList.length;i++){
        setState((){
          groupArray.add(groupsList[i]);
          });      
        }
      print("OUTSIDE FUNCTION ->"+groupArray.toString());
    }
  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marathon Groups"),
        backgroundColor: Constants.bright_red,
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (choice) => onItemMenuPress(choice, context),
              itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
              },
            ),
          ],
      ),
      backgroundColor: Constants.bright_white,
      body: ListView(
          children: <Widget>[
            SizedBox(height:10.0),
            GridView.count(
              padding: EdgeInsets.only(left:10.0, right:10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary:false,
              shrinkWrap: true,
              children: groupArray.map((element) {
                return buildResultCard(element, element,context, null, updateList);
              }).toList()),
          ],
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