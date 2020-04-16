import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../mrthn/mrth_api.dart';
import './edit_profile.dart';

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class ProfilePage extends StatefulWidget {

  var profileref;


  @override
  _ProfilePage createState() => _ProfilePage(profileref);
  ProfilePage(this.profileref);
  
}

class _ProfilePage extends State<ProfilePage>{

  var profileref;
  _ProfilePage(this.profileref);

  var friendCount;
  var groupCount;
  var username = 'loading';

  @override
  void initState() {
    super.initState();
    updateUI();
  }
  
  void updateUI() async{
    await Constants.dbManagement.getFriendsArray(profileref).get().then((datasnapshot){
        if (datasnapshot.exists) {
        username = datasnapshot.data['name'];
        friendCount = datasnapshot.data['friends'].length;
        groupCount = datasnapshot.data['groups'].length;
      }
    setState(()  {
      });
    });
  }

  static const List<String> profile_choices = <String>[
  'Edit Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Constants.bright_purple,
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (choice) => choiceAction(choice, context),
              itemBuilder: (BuildContext context) {
              return profile_choices.map((String choice) {
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
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25.0), // spacing
                Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(62.5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/background1.jpg'))),
                ),
                SizedBox(height: 25.0),
                Text(
                  username,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Waterloo, ON',
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                ),
                Padding(
                padding: EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '100',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Steps',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          groupCount.toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'GROUPS',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          friendCount.toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Friends',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
              ],
          ),],
        ),
      ),
    );
  }
  
  void choiceAction(String choice, BuildContext context) {
    if (choice == "Edit Profile") {
      showDialog(
        context: context,
        builder: (context) {
          return EditProfile();
        });
    }
  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
