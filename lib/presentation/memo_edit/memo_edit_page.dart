import 'package:dokugaku/presentation/main/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditWidget extends StatelessWidget {
  final String _uuid;
  final MemoListItem _item;
  final _EditInfo _editInfo = new _EditInfo();

  EditWidget(this._uuid, this._item);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              MemoListItem? item = _item;
              if (_editInfo.isChanged == false) item = null;
              Navigator.pop(context, item);
            }),
        title: new Text(this._uuid),
      ),
      body: SafeArea(
          child: Column(
        children: [
          _TitleText(_item, _editInfo),
          _TextArea(_item, _editInfo),
        ],
      )),
    );
  }
}

// タイトル
class _TitleText extends Container {
  _TitleText(MemoListItem item, _EditInfo editInfo)
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
                editInfo.isChanged = true;
                item.memo.title = text;
              },
            ));
}

// テキストエリア
class _TextArea extends Expanded {
  _TextArea(MemoListItem item, _EditInfo editInfo)
      : super(
          child: Container(
            //color: Colors.teal,
            width: double.infinity,
            padding: EdgeInsets.all(14.0),
            child: TextField(
              enabled: true,
              maxLines: null,
              controller: TextEditingController(text: item.memo.text),
              decoration: new InputDecoration(
                  // 色々変更
                  ),
              onChanged: (text) {
                editInfo.isChanged = true;
                item.memo.text = text;
              },
            ),
          ),
        );
}

// 情報用
class _EditInfo {
  bool isChanged = false;
}
