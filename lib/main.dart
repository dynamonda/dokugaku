import 'package:dokugaku/database_helper.dart';
import 'package:dokugaku/dialog.dart';
import 'package:dokugaku/edit_widget.dart';
import 'package:dokugaku/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

void main() async {
  runApp(MyApp());

  DatabaseHelper.instance.close();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dokugaku'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final dbHelper = DatabaseHelper.instance;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MemoListItem {
  final MemoModel memo;

  MemoListItem(this.memo);
}

class MemoModel {
  late String uuid;
  late String title;
  late String text;

  DateTime createdDateTime = DateTime.now();
  DateTime updatedDateTime = DateTime.now();

  MemoModel({required this.uuid, required this.title, required this.text});

  Map<String, Object?> toMap() {
    final nowTime = DateTime.now().toIso8601String();
    var map = <String, Object?>{
      'id': uuid,
      'created_at': nowTime,
      'updated_at': nowTime,
      'title': title,
      'text': text
    };
    return map;
  }

  MemoModel.fromMap(Map<String, Object?> map) {
    uuid = map['id'].toString();
    title = map['title'].toString();
    text = map['text'].toString();

    createdDateTime = DateTime.parse(map['created_at'].toString());
    updatedDateTime = DateTime.parse(map['updated_at'].toString());
  }

  String toString() {
    return "MemoModel, id=$uuid, title=$title, text=$text";
  }
}

class AnimatedListItemWidget extends StatelessWidget {
  final MemoListItem item;
  final Animation<double> animation;
  final VoidCallback onClicked;
  final String uuid;
  final VoidCallback? onUpdated;

  const AnimatedListItemWidget({
    required this.item,
    required this.animation,
    required this.onClicked,
    required this.uuid,
    Key? key,
    this.onUpdated,
  }) : super(key: key);

  // ここでリストの見た目を作る
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: Icon(Icons.text_snippet),
        title: Text(item.memo.title),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onClicked();
          },
        ),
        onTap: () async {
          // エディット画面に遷移
          MemoListItem? result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWidget(this.uuid, item)));

          if (result != null) {
            // DBを更新
            await DatabaseHelper.instance.update(result.memo);
            onUpdated?.call();
          } else {
            print('変更がないので、更新しません。');
          }
        },
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final key = GlobalKey<AnimatedListState>();
  List<MemoListItem> _lists = [
    //AnimatedListItem("項目1"),
    //AnimatedListItem("項目2"),
    //AnimatedListItem("項目3"),
  ];

  Widget buildAnimatedListItem(
      MemoListItem item, int index, Animation<double> animation) {
    return AnimatedListItemWidget(
      item: item,
      animation: animation,
      onClicked: () async {
        // DBから削除する
        var count = await DatabaseHelper.instance.delete(item.memo);
        if (count > 0) {
          // 元のリストから削除
          final removedItem = _lists.removeAt(index);

          // アニメーションリストから削除
          key.currentState!.removeItem(index, (context, animation) {
            return buildAnimatedListItem(removedItem, index, animation);
          });
        }
      },
      uuid: Util.uuid.v4(),
      onUpdated: () {
        print('更新しました。');
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // DBにインサートしてから、リストを更新
              var memo = MemoModel(
                  uuid: Util.uuid.v4(),
                  title: "新しいメモ",
                  text: "");
              var memoItem = MemoListItem(memo);

              var insertResult = await DatabaseHelper.instance.insert(memo);

              // 成功したらリスト更新
              if (insertResult > 0) {
                var index = _lists.length;
                _lists.insert(index, memoItem);
                key.currentState!.insertItem(index);
              }
            },
          )
        ],
      ),
      drawer: MyDrawer(context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'メモ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder(
                  future: DatabaseHelper.instance.getMemos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MemoModel>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    } else {
                      // DBから取り出してリストに入れてしまう
                      _lists.clear();
                      var memoList = snapshot.data!;
                      memoList.asMap().forEach((int i, MemoModel memo) {
                        var item = MemoListItem(memo);
                        _lists.add(item);
                      });

                      return AnimatedList(
                        key: key,
                        initialItemCount: memoList.length,
                        itemBuilder: (context, index, animation) {
                          var item = _lists[index];
                          return buildAnimatedListItem(item, index, animation);
                        },
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder(
                future: DatabaseHelper.instance.getMemos(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MemoModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return Text('0件です');
                    } else {
                      return Text(snapshot.data!.length.toString());
                    }
                  } else {
                    return Text('ここに表示');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends Drawer {
  MyDrawer(BuildContext context)
      : super(
          child: ListView(
            children: [
              ListTile(
                title: Text('db件数表示'),
                onTap: () async {
                  var count = await DatabaseHelper.instance.getCount('memos');
                  DialogUtil.messageDialogMessage(context, "memos 全$count件");
                },
              ),
              ListTile(
                title: Text('db削除'),
                onTap: () async {
                  await DatabaseHelper.debugDelete();
                  DialogUtil.messageDialogMessage(context, "memos テーブルを削除しました");
                },
              )
            ],
          ),
        );
}
