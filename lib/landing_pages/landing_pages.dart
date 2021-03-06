import 'package:flutter/material.dart';
import 'package:passive_marathon/home_pages/new_user_alert.dart';
import './page.dart';
import './dots.dart';
import './description_box.dart';
import '../home_pages/home_page.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import '../constants.dart' as Constants;
import '../db_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<dynamic> userData = new List<dynamic>();

  static var landingHeaders = [
    "Marathon",
    "Connect With Friends",
    "Reach Your Goals!",
  ];

  static var landingBody = [
    "Start a race with your friends and complete it at your own pace while incorporating fitness and competition. Beat your friends!",
    "Invite your friends, join groups and compete in challenges that keep you moving and grooving towards your goals.",
    "Set and achieve running goals with the help of Lazy Olympics! A tool to help improve fitness with a twist!",
  ];

  void _launchURL() async {
    final result = await FlutterWebAuth.authenticate(
        url: Constants.login_url, callbackUrlScheme: "passivemarathon");

    final mrthnUserId = Uri.parse(result).queryParameters['userId'];
    print(mrthnUserId);

    switch (int.parse(mrthnUserId)) {
      case 0:
        break;
      default:
        Constants.user_id = int.parse(mrthnUserId); // edit this to switch users
        Constants.dbManagement
            .checkUser(Constants.user_id.toString())
            .then((QuerySnapshot docs) {
          for (int i = 0; i < docs.documents.length; i++) {
            userData.add(docs.documents[i].data);
          }
          if (userData.length <= 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            print("showing alert");
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewUserAlert();
                });
          } else {
            Constants.dbManagement
                .setDBCodeNameRef(docs.documents[0].documentID);
            Constants.user_name = userData[0]["name"];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        });
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
              left: 120,
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
