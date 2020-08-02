import 'package:flutter/cupertino.dart';

class MainAppStateProvider with ChangeNotifier {
  bool _scrollEnabled = false;

  bool get scrollEnabled => _scrollEnabled;

  set setscrollEnabled(bool scrollEnabled) {
    _scrollEnabled = scrollEnabled;
    notifyListeners();
  }
}
