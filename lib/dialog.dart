import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialog {
  // メッセージダイアログを表示する
  static messageDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  static messageDialogMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }
}

// Yes/Noのダイアログを表示（OK, キャンセル）
yesNoDialogMessage(
    BuildContext context, String message, VoidCallback yesCallback) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  yesCallback.call();
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      });
}
