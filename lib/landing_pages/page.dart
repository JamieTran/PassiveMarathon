import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants.dart' as Constants;

class Page extends StatelessWidget {
  final page;
  final idx;

  Page({
    @required this.page,
    @required this.idx,
  });

  static var backgroundAssets = [
    "assets/images/background1.png",
    "assets/images/background2.png",
    "assets/images/background3.png",
  ];

  onTap() {
    print("${this.idx} selected.");
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundAssets[idx]),
          fit: BoxFit.cover,
        ),
      ),
      child: new Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
           new Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/donuts.png', width: 220,)
                ),
              ),
            ),
            
            new Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Lazy Olympics',
                    style: TextStyle(
                          fontFamily: 'MagicDreams',
                          fontSize: 40,
                          color: Constants.salmon_darkBlue),
                  ),
                ),
              ),
            ),

          this.page,
          new Material(
            type: MaterialType.transparency,
            child: new InkWell(onTap: this.onTap),
          ),
        ],
      ),
    );
  }
}
