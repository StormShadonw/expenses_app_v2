import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function handler;
  final String buttonText;

  AdaptiveFlatButton({this.handler, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler,
          )
        : FlatButton(
            onPressed: handler,
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
