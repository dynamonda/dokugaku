import 'dart:ffi';

import 'package:dokugaku/dialog.dart' as MyDialog;
import 'package:flutter/material.dart';

class ListItem {
  String _title;
  IconData _icon;

  // コンストラクタ
  ListItem(this._title, this._icon);

 ListTile build(BuildContext context, List list, int index) {
    /*return new Dismissible(
      key: ObjectKey(this),   // 一意じゃないとダメらしい
      child:*/
      return new ListTile(
        leading: Icon(_icon),
        title: Text(_title),
        onTap: () {
          MyDialog.Dialog.messageDialogMessage(context, _title);
        },
        onLongPress: () {
          MyDialog.yesNoDialogMessage(context, '削除しますか？', (){});
        },
      );
      /*
      onDismissed: (direction){
        context.setState(() {
          list.removeAt(index);
        });
      },
    );*/
  }
}
