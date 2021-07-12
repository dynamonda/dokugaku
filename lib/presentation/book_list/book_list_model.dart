import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokugaku/domain/book.dart';
import 'package:flutter/cupertino.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  // Firebaseから取得してbooksに代入
  Future fetchBooks() async {
    final docs = await FirebaseFirestore.instance.collection('books').get();
    final books = docs.docs
        .map((doc) => Book(doc.reference.id, doc['title'], doc['author']))
        .toList();
    this.books = books;
    notifyListeners();
  }

  Future deleteBook(Book book) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.documentID)
        .delete();
  }
}
