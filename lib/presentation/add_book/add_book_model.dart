import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokugaku/domain/book.dart';
import 'package:flutter/cupertino.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';
  String bookAuthor = '';

  Future addBook() async {
    if(bookTitle.isEmpty || bookAuthor.isEmpty){
      throw('タイトルと作者名を追加してください');
    }

    await FirebaseFirestore.instance
        .collection('books')
        .add({'title': bookTitle, 'author': bookAuthor});
  }
}
