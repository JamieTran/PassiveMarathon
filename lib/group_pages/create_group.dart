import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/group_pages/group_page.dart';
import 'package:intl/intl.dart';
import '../constants.dart' as Constants;

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

            var now = new DateTime.now();
            var formatter = new DateFormat('yyyy-MM-dd');
            String date = formatter.format(now);

            Constants.dbManagement.createGroup(groupName.text, _value, date);
          },
        )
      ],
    );
  }
}

Widget buildGroupRedirectCard(groupName, context, index) {
  return new GestureDetector(
  onTap: ()=> Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => GroupScreen(groupName)),
    ),
      child: new Card(
        child: ListTile(
          leading: Icon(Icons.flag, color: Constants.placement_colors[index]),
          title: Text(groupName),
        ),
      ));
}