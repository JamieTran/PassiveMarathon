import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passive_marathon/db_management.dart';
import 'package:passive_marathon/friend_pages/friend_add_page.dart';
import '../constants.dart' as Constants;
import 'friend_add_page.dart';

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
          stream: Firestore.instance.collection('users').document(DatabaseManagement().getUserRef()).snapshots(),
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
                      return Card(
                                  child: ListTile(
                                    onTap: null,    // REDIRECT TO USER PROFILE HERE, I didn't test it but it should work, I hope
                                    leading: Icon(Icons.account_circle),
                                    title: Text('$key'),
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
