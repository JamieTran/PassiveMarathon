import 'dart:io';

import 'package:flutter/material.dart';
import './page.dart';
import './dots.dart';
import './description_box.dart';
import '../home_pages/home_page.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../constants.dart' as Constants;

class LandingPages extends StatefulWidget {
  @override
  State createState() => new LandingPagesState();
}

class LandingPagesState extends State<LandingPages> {
  Widget _buildPageItem(BuildContext context, int index) {
    return new Page(page: _pages[index], idx: index);
  }

  final _controller = new PreloadPageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  static var landingHeaders = [
    "Marathon",
    "Something About Friends",
    "Reach Your Goals!",
  ];

  static var landingBody = [
    "Start a race with your friends and complete it at your own time while incorperating fitness and competition. Beat your friends!",
    "Your friends stand no chance when they compete with Passive Marathon. Get your distance in while destroying the enemy.",
    "Set and achieve running goals with the help of Passive Marathon! A tool to help improve fitness and create ",
  ];

  void _launchURL() async {
    final result = await FlutterWebAuth.authenticate(
        url: Constants.login_url, callbackUrlScheme: "passivemarathon");

    final token = Uri.parse(result).queryParameters['userId'];

    switch (int.parse(token)) {
      case 0:
        break;
      default:
      // TODO: Add saving of user to login constants
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
    }
  }

  final List<Widget> _pages = <Widget>[
    new DescriptionBox(landingHeaders[0], landingBody[0]),
    new DescriptionBox(landingHeaders[1], landingBody[1]),
    new DescriptionBox(landingHeaders[2], landingBody[2]),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            new PreloadPageView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildPageItem(context, index % _pages.length);
              },
              preloadPagesCount: 3,
            ),
            new Positioned(
              bottom: 80,
              left: 25,
              child: ButtonTheme(
                height: 50,
                minWidth: 135,
                child: RaisedButton(
                  color: Colors.grey[800].withOpacity(0.5),
                  onPressed: () {
                    this._launchURL();
                  },
                  child: const Text('Sign Up / Log In',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            new Positioned(
              bottom: 80,
              right: 25,
              child: ButtonTheme(
                height: 50,
                minWidth: 135,
                child: RaisedButton(
                  color: Colors.grey[800].withOpacity(0.5),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Text('Continue',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: new Container(
                color: Colors.grey[800].withOpacity(0.5),
                padding: const EdgeInsets.all(20.0),
                child: new Center(
                  child: new DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
