import 'package:flutter/material.dart';

class BaseAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final String yes;
  final String no;
  final Function yesOnPressed;
  final Function noOnPressed;

  BaseAlertDialog(this.title, this.content, this.yesOnPressed, this.noOnPressed,
      this.yes, this.no);

  @override
  _BaseAlertDialogState createState() => _BaseAlertDialogState();
}

class _BaseAlertDialogState extends State<BaseAlertDialog> {
  Color color = Color.fromARGB(220, 117, 218, 255);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(widget.title),
      content: new Text(widget.content),
      backgroundColor: color,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: new Text(widget.yes),
          textColor: Colors.greenAccent,
          onPressed: () {
            widget.yesOnPressed();
          },
        ),
        new FlatButton(
          child: Text(widget.no),
          textColor: Colors.redAccent,
          onPressed: () {
            widget.noOnPressed();
          },
        ),
      ],
    );
  }
}
