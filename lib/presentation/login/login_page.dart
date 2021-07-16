import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('ログイン')),
        body: Consumer<LoginModel>(builder: (context, model, child) {
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
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        await model.login();
                        await _showDialog(context, 'ログインしました');
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
