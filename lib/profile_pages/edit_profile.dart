import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State{

  TextEditingController groupName = TextEditingController();
  double _value = 42;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
          child: Column( 
            children: <Widget> [
              TextField(
                controller: groupName,
                decoration: InputDecoration(hintText: "Name of Group"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text("Distance"),
              ),
              Slider(
                value: _value.toDouble(),
                min: 0.1,
                max: 42,
                divisions: 420,
                activeColor: Colors.red,
                inactiveColor: Colors.black,
                label: _value.toStringAsFixed(1) + " kms",
                onChanged: (double newValue) {
                  setState(() {
                    _value = newValue;
                  });
                },
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