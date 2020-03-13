import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import './distance_slider.dart';

class CreateGroup extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupState();
  }
}
    
class _CreateGroupState extends State{

  TextEditingController groupName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a new Marathon'),
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
              DistanceSlider(),
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
          child: new Text('ADD'),
          onPressed: () {
            Navigator.of(context).pop();
            
          },
        )
      ],
    );
  }

}