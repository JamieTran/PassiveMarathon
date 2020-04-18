import 'package:flutter/material.dart';
import 'package:passive_marathon/group_pages/group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/group_pages/marathon_groups.dart';
import '../db_management.dart';
import '../constants.dart' as Constants;

class AddMember extends StatefulWidget{

 var groupData;

  @override 
    _AddMemberState createState() => _AddMemberState(groupData);

    AddMember(this.groupData);
}
    
class _AddMemberState extends State<AddMember>{

  @override
  void initState() {
  super.initState();
  updateList();
  }

  var groupData;

  _AddMemberState(this.groupData);

Map<String, String> friendsList = new Map<String, String>();
List<Map<String, String>> list = new List<Map<String, String>>();
var friendArray =[];
var refArray= [];
var docIDSet = {};

getMapContent(Map list, String object)
{
  var value = list.values.toList();
  var key = list.keys.toList();
  String result;

  switch (object)
  {
    case 'key':
      result = key[0];
    break;
    case 'value':
      result = value[0];
    break;
  }

  return result;
}

updateList()
{
  friendArray.clear();
  refArray.clear();
  friendsList.clear(); 
  Constants.dbManagement.getFriendsArray(Constants.dbManagement.getUserRef()).get().then((datasnapshot) {
    if (datasnapshot.exists) {
      friendsList = Map.from(datasnapshot.data['friends']);
         friendsList.forEach((k,v) => 
          setState(() {
            list.add({k:v});
          }));

      print("OUTSIDE FUNCTION Friends->"+refArray.toString());
    }
  });
}

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text('Add Friend To Marathon'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            SizedBox(height:10.0),
            GridView.count(
              padding: EdgeInsets.only(left:10.0, right:10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary:false,
              shrinkWrap: true,
              children:
                  list.map((element) {
                  return buildResultCard(groupData,getMapContent(element, "key"),getMapContent(element, "value") ,context, Constants.add_friend_to_group,null);
                  }).toList(),
            )],
        )
      );
  }
}

Widget buildResultCard(groupData, dataObjectKey, dataObjectValue, context, feature, Function updateFunc) {
  return new GestureDetector(
  onTap: ()=> showAlertDialog(context, groupData, dataObjectKey, dataObjectValue, feature, updateFunc),
  child: new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center (
          child: Text(dataObjectKey,
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

showAlertDialog(BuildContext context, groupData, dataObjectKey, dataObjectValue, int feature, Function updateFunc) {
  // set up the buttons
  switch (feature)
  {
    case Constants.add_friend_to_group: {
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

          // Send Invite 
          Constants.dbManagement.sendGroupInvite(groupData, dataObjectValue);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Add Friend To Group"),
        content: Text("Would you like to send "+dataObjectKey+" an invite to your group?"),
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