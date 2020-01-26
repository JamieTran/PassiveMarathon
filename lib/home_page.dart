import 'package:flutter/material.dart';

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
        title:new Text("Passive Marathon")
      ),
      body: new Container(
        child: new Center(
          child: new Text("Passive Marathon"),
        ),
      )
    );
  }
}