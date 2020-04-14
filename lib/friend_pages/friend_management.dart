import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import '../constants.dart' as Constants;
import 'friend_add_page.dart';
import '../profile_pages/profile_page.dart';

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon

class FriendScreen extends StatefulWidget {
  @override 
    FriendsManagement createState() => FriendsManagement();
}

class FriendsManagement extends State<FriendScreen> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        backgroundColor: Constants.bright_blue,
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
              //String result = await Navigator.of(context).pushNamed('/friendadd');
               await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendAdd()));
              },
            ),
        ]),
      backgroundColor: Constants.bright_white,
      body:
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(Constants.dbManagement.getUserRef()).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)
          {
            if (snapshot.hasError) {
              return Text ('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState)
            {
              case ConnectionState.waiting:
                return Text ('Loading...');
              default:
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data['friends'].length,
                  itemBuilder: (_, int index) {
                    String key = snapshot.data['friends'].keys.elementAt(index);
                    String value = snapshot.data['friends'].values.elementAt(index);
                      return Dismissible(
                        background: Container(color: Colors.red),
                        confirmDismiss: (DismissDirection direction) async {
                          final bool res = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text("Are you sure you wish to delete this friend?"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => {
                                      print(value),
                                      Constants.dbManagement.removeFriend(value),
                                      Navigator.of(context).pop(true)
                                      },
                                    child: const Text("DELETE")
                                  ),
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                          return res;
                        },
                        key: Key(key),
                        child: new Card(
                          child: ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage()));
                                },
                            leading: Icon(Icons.account_circle),
                            title: Text('$key'),
                          ),
                      ), 
                    );
                  }
                );     
            }
          },
        )
    );
  }
}
