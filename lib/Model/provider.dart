import 'package:flutter/material.dart';

class passwordshow with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  void setloading(bool value) {
    _loading = !value;
    notifyListeners();
  }

  
}


