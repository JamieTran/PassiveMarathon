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
    // TODO: make user & date dynamic for what is being requested
    // TODO: also make authentication token private
    final response = await http.get(
    'https://marathon-web-api-staging.herokuapp.com/user/1/steps?date=2020-03-15',
      headers: {HttpHeaders.authorizationHeader: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI2IiwiaXNzIjoiTWFyYXRob24ifQ.PY_7DnSqhgvromUG8x7JSUJl2AdA8sR14vFcaz-vtMM"},
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