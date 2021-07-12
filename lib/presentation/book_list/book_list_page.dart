import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokugaku/domain/book.dart';
import 'package:dokugaku/presentation/add_book/add_book_page.dart';
import 'package:dokugaku/presentation/book_list/book_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
        // foo()..func()  カスケード記法というらしい
        // qiita.com/Nedward/items/b71512f8c2997f52697d
        create: (_) => BookListModel()..fetchBooks(),
        child: Scaffold(
          appBar: AppBar(title: Text('firebase')),
          body: Consumer<BookListModel>(builder: (context, model, child) {
            final books = model.books;
            final listTiles = books
                .map((book) => ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          // 本の情報を変更する画面に遷移
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddBookPage(
                                        book: book,
                                      ),
                                  fullscreenDialog: true));
                          await model.fetchBooks();
                        },
                      ),
                      onLongPress: () async {
                        // 長押し削除
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('${book.title}を削除しますか？'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  // 削除apiを叩く
                                  await deleteBook(context, model, book);
                                },
                              )
                            ],
                          );
                        });
                      },
                    ))
                .toList();
            return ListView(
              children: listTiles,
            );
          }),
          floatingActionButton:
              Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  // 本を追加に遷移
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBookPage(),
                          fullscreenDialog: true));
                  await model.fetchBooks();
                });
          }),
        ));
  }

  Future deleteBook(BuildContext context, BookListModel model, Book book) async {
    try {
      await model.deleteBook(book);
      await model.fetchBooks();
      //await _showDialog(context, '削除しました'); なんかエラーが出る
    } catch (e) {
      await _showDialog(context, e.toString());
    }
  }

  Future _showDialog(BuildContext context, String title) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
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
