import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {

  Color bgColor;
  Color iconColor;
  Color textColor;
  String text;
  MaterialPageRoute route;
  IconData icon;

  NavButton(this.bgColor, this.iconColor, this.textColor, this.text, this.icon, this.route);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: bgColor,
      child: new FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            route
            );  
        },
          child: Column( // Replace with a Row for horizontal icon + text
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(icon, size: 100.0, color: iconColor),
              Text(text, style: TextStyle(color: textColor))
            ],
          ),
      ),
    );
  }

}