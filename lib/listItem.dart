import 'package:dokugaku/dialog.dart' as MyDialog;
import 'package:flutter/material.dart';

class ListItem {
  String _title;
  IconData _icon;

  // コンストラクタ
  ListItem(this._title, this._icon);

  ListTile build(BuildContext context) {
    return new ListTile(
      leading: Icon(_icon),
      title: Text(_title),
      onTap: () {
        print("onTap: name=$_title");
      },
      onLongPress: () {
        print("onLongPress: name=$_title");
        MyDialog.Dialog.messageDialog(context, _title);
      },
    );
  }
}
