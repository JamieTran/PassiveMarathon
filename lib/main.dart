// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import './landing_pages/landing_pages.dart';
import './home_pages/home_page.dart';
import 'constants.dart' as Constants;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(new AssetImage("assets/images/background1.jpg"), context);
    precacheImage(new AssetImage("assets/images/background2.jpg"), context);
    precacheImage(new AssetImage("assets/images/background3.jpg"), context);

    return new MaterialApp(
      title: 'Flutter Demo',
      home: new LandingPages(),
      debugShowCheckedModeBanner: false,
    );
  }
}
