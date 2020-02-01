import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

// Stateful widgets are used when you need to update the screen
// with data constantly, this works for passive marathon
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Constants.bright_yellow,
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
}