import 'package:dokugaku/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWidget extends StatelessWidget {
  final String _uuid;
  final MemoListItem _item;

  EditWidget(this._uuid, this._item);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: new Text(this._uuid),
      ),
      body: SafeArea(
          child: Column(
        children: [
          _TitleText(_item),
          _TextArea(),
        ],
      )),
    );
  }
}

// タイトル
class _TitleText extends Container {
  _TitleText(MemoListItem item)
      : super(
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              maxLines: 1,
              minLines: 1,
              controller: TextEditingController(text: item.memo.title),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (text) {
                item.memo.title = text;
              },
            ));
}

// テキストエリア
class _TextArea extends Expanded {
  _TextArea()
      : super(
          child: Container(
            //color: Colors.teal,
            width: double.infinity,
            padding: EdgeInsets.all(14.0),
            child: TextField(
              enabled: true,
              maxLines: null,
              decoration: new InputDecoration(
                  // 色々変更
                  ),
            ),
          ),
        );
}
