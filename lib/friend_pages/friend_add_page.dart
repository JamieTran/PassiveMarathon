// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';

class FriendAdd extends StatefulWidget {
  @override 
    FriendAddState createState() => FriendAddState();
}

class FriendAddState extends State<FriendAdd> {

var queryResultSet = [];
var tempSearchStore = [];

initiateSearch(username) {
  // If user backspaces, clear arrays
    if (username.length ==0) {
      setState(() {
      queryResultSet = [];
      tempSearchStore = [];
      });
    }

    var capitalizedValue = 
      username.substring(0,1).toUpperCase() + username.substring(1);

  if (queryResultSet.length == 0 && username.length == 1) {
    DatabaseManagement().queryUsers(username).then((QuerySnapshot docs) {
      for (int i=0;i<docs.documents.length;i++){
        queryResultSet.add(docs.documents[i].data);
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
          title: Text('Search for Friends'),
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
                return buildResultCard(element, context);
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
          child: Text(data['name'],
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
      DatabaseManagement().addFriend(data['name']);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Add Friend"),
    content: Text("Would you like to add "+data['name']+" as your friend?"),
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
