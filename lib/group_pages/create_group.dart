import 'package:flutter/material.dart';
import './distance_slider.dart';

class CreateGroup extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupState();
  }
}
    
class _CreateGroupState extends State{
  @override
  Widget build(BuildContext context) {
          return AlertDialog(
            title: Text('Add a new Marathon'),
            content: Column( 
              children: <Widget> [
                TextField(
                  decoration: InputDecoration(hintText: "Name of Group"),
                ),
                new DistanceSlider(),
                TextField(
                  decoration: InputDecoration(hintText: "Name of Group"),
                ),
              ],
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