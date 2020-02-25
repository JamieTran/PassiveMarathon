import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import '../constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class MarathonGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marathon Groups"),
        backgroundColor: Constants.bright_red,
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
              },
            ),
          ],
      ),
      backgroundColor: Constants.bright_white,
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
            },
          child: Text('Go back!'),
        ),
      ),
    );
  }
  
  void choiceAction(String choice) {
    if (choice == Constants.create_group) {
      print('Create Group page here');
    } else if (choice == Constants.add_group) {
      print('Add group page here');
    } else if (choice == Constants.leave_group) {
      print('Leave Group page here');
    }
  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}