import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: password);

    if(result.user != null)
    {
      final uid = result.user!.uid;

      // TODO: 端末に保存
    }
  }
}
