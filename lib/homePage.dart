import 'package:flutter/material.dart';
import './page.dart';
import './dots.dart';
import './descriptionBox.dart';
import 'package:preload_page_view/preload_page_view.dart';


class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

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
    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car seemed",
    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car seemed",
    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car seemed",
  ];

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
                  onPressed: () {},
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, color: Colors.white)
                  ),
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
                  onPressed: () {},
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, color: Colors.white)
                  ),
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