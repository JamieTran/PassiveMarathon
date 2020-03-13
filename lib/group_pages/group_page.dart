// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passive_marathon/db_management.dart';
import '../constants.dart' as Constants;

class GroupScreen extends StatefulWidget {
  @override 
    GroupPage createState() => GroupPage();
}

class GroupPage extends State<GroupScreen> {

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text('Group Title'),
          backgroundColor: Constants.bright_red,
        ),
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