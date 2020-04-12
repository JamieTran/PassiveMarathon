import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State{

  TextEditingController userName = TextEditingController();
  TextEditingController userLocation = TextEditingController();

  double _value = 42;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
          child: Column( 
            children: <Widget> [
              TextField(
                controller: userName,
                decoration: InputDecoration(hintText: "Name"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TextField(
                controller: userLocation,
                decoration: InputDecoration(hintText: "Location"),
                ),
              ),
            ],
          ),
        ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text('SAVE'),
          onPressed: () {
            print(_value);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
} 