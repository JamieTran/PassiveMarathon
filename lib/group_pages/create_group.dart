import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';

class CreateGroup extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupState();
  }
}
    
class _CreateGroupState extends State{

  TextEditingController groupName = TextEditingController();
  double _value = 42;

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
          child: new Text('ADD'),
          onPressed: () {
            print(_value);
            Navigator.of(context).pop();
            DatabaseManagement().createGroup(groupName.text, _value);
          },
        )
      ],
    );
  }

}

Widget buildResultCard(dataField, dataObject, context, feature, Function updateFunc) {
  return new GestureDetector(
  //onTap: ()=> ,
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