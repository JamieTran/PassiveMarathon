// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/group_pages/add_member.dart';
import '../constants.dart' as Constants;

class GroupScreen extends StatefulWidget {

  var groupData;

  @override 
    GroupPage createState() => GroupPage(groupData);

    GroupScreen(this.groupData);
}

class GroupPage extends State<GroupScreen> {

  var groupData;

  GroupPage(this.groupData);

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
          // Profile Page 
      },
    );
  }

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text(groupData.toString()),
          backgroundColor: Constants.bright_red,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMember(groupData))
            );  
              },
            ),
        ]
        ),
        backgroundColor: Constants.bright_white,
        body:
        Column(
          children :[
/*             TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Entire Race Progress Here'
              ),
            ), */
            Expanded( child: 
            StreamBuilder(
              stream: DatabaseManagement().getGroupStreamSnapShot(groupData),
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

Widget buildResultCard(dataField, dataObject, context, feature, Function updateFunc) {
  return new GestureDetector(
  //onTap: ()=> showAlertDialog(context, dataField, dataObject, feature, updateFunc),
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