import 'package:flutter/material.dart';

class ListItem {
  ListTile listTile = new ListTile();

  // コンストラクタ
  ListItem(String title, IconData icon){
    listTile = new ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: (){
        print("onTap: name=${listTile.title}");
      },
    );
  }
}