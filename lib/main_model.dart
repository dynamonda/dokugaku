import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String fooText = 'Foobar';

  void changeText() {
    fooText = 'Changed!';
    notifyListeners();    // => Consumer<MainModel>に発火する
  }
}
