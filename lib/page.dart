import 'package:flutter/material.dart';
import 'dart:ui';

class Page extends StatelessWidget {
  final page;
  final idx;

  Page({
    @required this.page,
    @required this.idx,
  });

  static var backgroundAssets = [
    "assets/images/background1.jpg",
    "assets/images/background2.jpg",
    "assets/images/background3.jpg",
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
      child: BackdropFilter (
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            this.page,
            new Material(
              type: MaterialType.transparency,
              child: new InkWell(onTap: this.onTap),
            ),
          ],
        ),
      ),
    );
  }
}