import 'package:dokugaku/database_helper.dart';
import 'package:dokugaku/edit_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() async {
  runApp(MyApp());
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

class AnimatedListItem {
  String name;
  AnimatedListItem(this.name);
}

class MemoModel {
  final String uuid;
  final String title;
  final String text;

  MemoModel({required this.uuid, required this.title, required this.text});
}

class AnimatedListItemWidget extends StatelessWidget {
  final AnimatedListItem item;
  final Animation<double> animation;
  final VoidCallback onClicked;
  final String uuid;

  const AnimatedListItemWidget({
    required this.item,
    required this.animation,
    required this.onClicked,
    required this.uuid,
    Key? key,
  }) : super(key: key);

  // ここでリストの見た目を作る
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: Icon(Icons.text_snippet),
        title: Text(item.name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onClicked();
          },
        ),
        onTap: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWidget(this.uuid, item)));
        },
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final key = GlobalKey<AnimatedListState>();
  var _lists = [
    AnimatedListItem("項目1"),
    AnimatedListItem("項目2"),
    AnimatedListItem("項目3"),
  ];

  Widget buildAnimatedListItem(item, int index, Animation<double> animation) {
    // uuidを求める
    var uuidObj = new Uuid();
    var uuid = uuidObj.v4();

    return AnimatedListItemWidget(
      item: item,
      animation: animation,
      onClicked: () {
        // 元のリストから削除
        final item = _lists.removeAt(index);

        // アニメーションリストから削除
        key.currentState!.removeItem(index, (context, animation) {
          return buildAnimatedListItem(item, index, animation);
        });
      },
      uuid: uuid,
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
            onPressed: () {
              //_addItemList();
              var index = _lists.length;

              _lists.insert(index, AnimatedListItem("項目${_lists.length + 1}"));
              key.currentState!.insertItem(index);
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('項目1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('項目2'),
              onTap: () {},
            )
          ],
        ),
      ),
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
              child: AnimatedList(
                key: key,
                initialItemCount: _lists.length,
                itemBuilder: (context, index, animation) {
                  var item = _lists[index];
                  return buildAnimatedListItem(item, index, animation);
                },
              ),
            ),
            //),
          ],
        ),
      ),
    );
  }
}
