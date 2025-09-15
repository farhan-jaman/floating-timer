import 'package:flutter/material.dart';

class SettingsHelper extends ChangeNotifier {
  bool _isSettings = false;

  bool get isSettings => _isSettings;

  void changePage(bool settings) {
    _isSettings = settings;
    notifyListeners();
  }
}