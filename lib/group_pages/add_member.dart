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

  var groupData;

  _AddMemberState(this.groupData);

var queryResultSet = [];
//List<String> queryResultSet;
var tempSearchStore = [];

List<String> friendsList = new List<String>();
var friendArray =[];
var docIDSet = {};

initiateSearch(username) {
  // If user backspaces, clear arrays
    if (username.length ==0) {
      setState(() {
      queryResultSet = [];
      tempSearchStore = [];

      friendArray.clear();
      friendsList.clear();
      docIDSet.clear();
      });
    }

  // To Enable Searching, (which doesnt work) Uncomment the following lines

  var capitalizedValue = username.substring(0,1).toUpperCase() + username.substring(1);

  if (queryResultSet.length == 0 && username.length == 1) {
    DatabaseManagement().queryUsers(username).then((QuerySnapshot docs) {
      for (int i=0;i<docs.documents.length;i++){
        queryResultSet.add(docs.documents[i].data);
        docIDSet[docs.documents[i].data['name']] = docs.documents[i].documentID;
      }
    });
  }
  else
  {
    tempSearchStore = [];
    queryResultSet.forEach((element) {
      if (element['name'].startsWith(capitalizedValue)){
        setState((){
          tempSearchStore.add(element);
          });
        }
      });
    }
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
              child: TextField(
                onChanged: (val) {
                  initiateSearch(val);
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize:20.0,
                    onPressed:() {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left:25.0),
                  hintText: 'Search for name',
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0))
                ),
              ),
            ),
            SizedBox(height:10.0),
            GridView.count(
              padding: EdgeInsets.only(left:10.0, right:10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary:false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(groupData,element, context, Constants.add_friend_to_group,null);
              }).toList()),
         ],
        )
      );
  }
}

Widget buildResultCard(groupData, dataObject, context, feature, Function updateFunc) {
  return new GestureDetector(
  onTap: ()=> showAlertDialog(context, groupData, dataObject, feature, updateFunc),
  child: new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center (
          child: Text(dataObject,
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

showAlertDialog(BuildContext context, groupData, dataObject, int feature, Function updateFunc) {
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
          //DatabaseManagement().addFriendToGroup(dataObject, groupData);

          // Should send Invite
          //DatabaseManagement().sendGroupInvite(groupData, dataObject);
         // DatabaseManagement().sendFriendInvite(data);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Add Friend To Group"),
        content: Text("Would you like to send "+dataObject+" an invite to your group?"),
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