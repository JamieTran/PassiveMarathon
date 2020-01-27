import 'package:flutter/material.dart';
import 'marathon_groups.dart';
import 'friend_management.dart';
import 'constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class HomePage extends StatefulWidget{
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title:new Text("Passive Marathon", style: TextStyle(color: Constants.salmon_eggshell)),
        backgroundColor: Constants.salmon_black,
      ),
      backgroundColor: Constants.bright_white,
      body: new GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_red,
            child: new FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarathonGroups()),
                  );              
                },
                child: Column( // Replace with a Row for horizontal icon + text
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.directions_run, size: 100.0, color: Constants.bright_white),
                    Text("Marathons", style: TextStyle(color: Constants.bright_white))
                  ],
                ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_blue,
            child: new FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendsManagement()),
                  );  
              },
                child: Column( // Replace with a Row for horizontal icon + text
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.group, size: 100.0, color: Constants.bright_white),
                    Text("Friends", style: TextStyle(color: Constants.bright_white))
                  ],
                ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_purple,
            child: new FlatButton(
              onPressed: () {
                /*...*/
              },
              child: Column( // Replace with a Row for horizontal icon + text
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.account_circle, size: 100.0, color: Constants.bright_white),
                  Text("Profile", style: TextStyle(color: Constants.bright_white))
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_yellow,
            child: new FlatButton(
              onPressed: () {
                /*...*/
              },
              child: Column( // Replace with a Row for horizontal icon + text
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.settings, size: 100.0, color: Constants.bright_white),
                  Text("Settings", style: TextStyle(color: Constants.bright_white))
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_white,
            child: new FlatButton(
              onPressed: () {
                /*...*/
              },
              child: Text(
                "Extra Option 1",
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Constants.bright_white,
            child: new FlatButton(
              onPressed: () {
                /*...*/
              },
              child: Text(
                "Extra Option 2",
              ),
            ),
          ),
        ],
      ),
    );
  }
}