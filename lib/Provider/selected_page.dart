import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedPageIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }
}
