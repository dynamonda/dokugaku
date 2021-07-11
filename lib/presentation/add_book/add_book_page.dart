import 'package:dokugaku/presentation/add_book/add_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      // foo()..func()  カスケード記法というらしい
      // qiita.com/Nedward/items/b71512f8c2997f52697d
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('本を追加')),
        body: Consumer<AddBookModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (text) {
                    model.bookTitle = text;
                  },
                ),
                TextField(
                  onChanged: (text) {
                    model.bookAuthor = text;
                  },
                ),
                ElevatedButton(
                    child: Text("追加"),
                    onPressed: () async {
                      // firestoreに本を追加
                      try {
                        await model.addBook();
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('保存しました'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      // なにこれ？
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                        Navigator.of(context).pop();
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      // なにこれ？
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    })
              ],
            ),
          );
        }),
      ),
    );
  }
}
