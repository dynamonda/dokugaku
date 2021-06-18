import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialog {
  // メッセージダイアログを表示する
  static messageDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }
}
