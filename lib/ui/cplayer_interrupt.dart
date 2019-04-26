import 'package:flutter/material.dart';

class ErrorInterruptMixin extends StatelessWidget {

  final IconData icon;
  final String title;
  final String message;

  ErrorInterruptMixin({
    this.icon = Icons.error,
    this.title = "Well this is awkward...",
    this.message = "An error occurred. Please try again."
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Icon(icon, size: 48),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(title, style: TextStyle(
              fontFamily: 'GlacialIndifference',
              fontSize: 30
          )),
        ),
        Text(message, style: TextStyle(fontSize: 16))
      ],
    );
  }

}