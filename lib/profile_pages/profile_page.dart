import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class ProfilePage extends StatelessWidget {
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
      fetchSteps();
    } else if (choice == Constants.add_group) {
      print('Add group page here');
    } else if (choice == Constants.leave_group) {
      print('Leave Group page here');
    }
  }

  Future<http.Response> fetchSteps() async {
    final response = await http.get(
    'https://marathon-web-api.herokuapp.com/user/1/steps',
      // Send authorization headers to the backend.S
      headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIzIiwiaXNzIjoiTWFyYXRob24ifQ.f6FWsbhF1IabP0ItC2nNCoLxlpFuHBne8kYw_FrVRAY"},
    );
    print(response);
    final responseJson = json.decode(response.body);

    print(responseJson);

  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}