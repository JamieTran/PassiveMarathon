import 'package:flutter/material.dart';

class DescriptionBox extends StatelessWidget {
  String descriptionHeader;
  String descriptionBody;

  DescriptionBox(
    this.descriptionHeader,
    this.descriptionBody,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey[800].withOpacity(0.5),
        width: 350,
        height: 250,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                descriptionHeader,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    color: Colors.white),
              ),
            ),
            Text(
              descriptionBody,
              style: TextStyle(
                  fontFamily: 'Montserrat', fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
