import 'package:dokugaku/domain/book.dart';
import 'package:dokugaku/presentation/add_book/add_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatelessWidget {
  final Book? book;
  AddBookPage({this.book});

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = book != null;
    final titleController = TextEditingController();
    final authorController = TextEditingController();

    if (isUpdate) {
      titleController.text = book!.title;
      authorController.text = book!.author;
    }

    return ChangeNotifierProvider<AddBookModel>(
      // foo()..func()  カスケード記法というらしい
      // qiita.com/Nedward/items/b71512f8c2997f52697d
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(title: Text(isUpdate ? '本を編集' : '本を追加')),
        body: Consumer<AddBookModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  onChanged: (text) {
                    model.bookTitle = text;
                  },
                ),
                TextField(
                  controller: authorController,
                  onChanged: (text) {
                    model.bookAuthor = text;
                  },
                ),
                ElevatedButton(
                    child: Text(isUpdate ? "更新" : "追加"),
                    onPressed: () async {
                      if (isUpdate) {
                        // 本の状態を更新
                        await updateBook(model, context);
                      } else {
                        // firestoreに本を追加
                        // note: メソッド分割するときawait忘れ気味なので注意
                        await addBook(model, context);
                      }
                    })
              ],
            ),
          );
        }),
      ),
    );
  }

  Future addBook(AddBookModel model, BuildContext context) async {
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
  }

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      if (model.bookTitle.isEmpty) {
        model.bookTitle = book!.title;
      }
      if (model.bookAuthor.isEmpty) {
        model.bookAuthor = book!.author;
      }

      await model.updateBook(book!);
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('更新しました'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
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
  }
}
