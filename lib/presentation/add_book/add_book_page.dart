import 'package:dokugaku/presentation/add_book/add_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          return Container();
        }),
      ),
    );
  }
}
