import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class SignupModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final User? user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail, password: password))
        .user;

    if (user != null) {
      final email = user.email;
      await FirebaseFirestore.instance
          .collection('users')
          .add({'email': email, 'createdAt': Timestamp.now()});
    }
  }
}
