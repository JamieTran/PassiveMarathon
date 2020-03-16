import 'package:flutter/material.dart';
import '../profile_pages/profile_page.dart';
import 'package:passive_marathon/settings_page.dart';
import '../group_pages/marathon_groups.dart';
import '../friend_pages/friend_management.dart';
import '../nav_button.dart';
import '../constants.dart' as Constants;

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
          new NavButton(Constants.bright_red, Constants.bright_white, Constants.bright_white, "Marathons", Icons.directions_run, MaterialPageRoute(builder: (context) => MarathonGroups())),
          new NavButton(Constants.bright_blue, Constants.bright_white, Constants.bright_white, "Friends", Icons.group,MaterialPageRoute(builder: (context) => FriendScreen())),
          new NavButton(Constants.bright_purple, Constants.bright_white, Constants.bright_white, "Profile", Icons.account_circle ,MaterialPageRoute(builder: (context) => ProfilePage())),
          new NavButton(Constants.bright_yellow, Constants.bright_white, Constants.bright_white, "Settings", Icons.settings ,MaterialPageRoute(builder: (context) => SettingsPage())),
        ],
      ),
    );
  }
}