import 'package:flutter/material.dart';

void main() {
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _listItems = [
    ListTile(
        leading: Icon(Icons.folder),
        title: Text('フォルダ1')
    ),
    ListTile(
        leading: Icon(Icons.note),
        title: Text('メモ1')
    ),
    ListTile(
        leading: Icon(Icons.text_snippet),
        title: Text('メモ2')
    )
  ];

  void _addItemList(){
    setState((){
      _listItems.add(
        ListTile(
          leading: Icon(Icons.text_snippet),
          title: Text("メモ${_listItems.length}")
        )
      );
      print('AddListItem');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('項目1'),
              onTap: (){

              },
            ),
            ListTile(
              title: Text('項目2'),
              onTap: (){

              },
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'メモ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _listItems.length,
              itemBuilder: (BuildContext context, int index){
                return _listItems[index];
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemList,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
