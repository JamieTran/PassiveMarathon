import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> adminChoices = const <Choice>[
  const Choice(title: 'Invite Member', icon: Icons.add),
  const Choice(title: 'Delete Group', icon: Icons.delete_forever)
];

const List<Choice> memberChoices = const <Choice>[
  const Choice(title: 'Invite Member', icon: Icons.add),
  const Choice(title: 'Leave Group', icon: Icons.exit_to_app)
];
