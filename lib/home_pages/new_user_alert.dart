import 'package:flutter/material.dart';
import '../db_management.dart';
import '../constants.dart' as Constants;

class NewUserAlert extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _NewUserAlertState();
  }
}

class _NewUserAlertState extends State{

  TextEditingController userName = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to Lazy Olympics!'),
      content: SingleChildScrollView(
          child: Column(  
            children: <Widget> [
              Text(
                "Who do you want to be known as?",
                style: TextStyle(fontSize: 15, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TextField(
                controller: userName,
                decoration: InputDecoration(hintText: "Name"),
                ),
              ),
            ],
          ),
        ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('SAVE'),
          onPressed: () {
            Constants.dbManagement.createUser(Constants.user_id, userName.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
} 