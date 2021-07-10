import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokugaku/prototype_book_list/book.dart';
import 'package:flutter/cupertino.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  // Firebaseから取得してbooksに代入
  Future fetchBooks() async {
    final docs = await FirebaseFirestore.instance.collection('books').get();
    final books =
        docs.docs.map((doc) => Book(doc['title'], doc['author'])).toList();
    this.books = books;
    notifyListeners();
  }
}
