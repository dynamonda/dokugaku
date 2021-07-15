import 'package:dokugaku/domain/book.dart';
import 'package:dokugaku/presentation/add_book/add_book_model.dart';
import 'package:dokugaku/presentation/signup/signup_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignupModel>(
      create: (_) => SignupModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('サインアップ')),
        body: Consumer<SignupModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(hintText: "example@hoo.co.jp"),
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: "パスワード"),
                  obscureText: true,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                ElevatedButton(
                    child: Text('登録する'),
                    onPressed: () async {
                      try {
                        await model.signUp();
                        await _showDialog(context, '登録完了しました');
                      } catch (e) {
                        await _showDialog(context, e.toString());
                      }
                    })
              ],
            ),
          );
        }),
      ),
    );
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
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
