import 'package:flutter/material.dart';

// ya hoga model catorgy ka color change krna ka liya
// provider ka sath
// simple setstate use kr skta haa
class ChipSelectionProvider extends ChangeNotifier {
  String selected = 'Any'; // default selection

  void selectChip(String category) {
    selected = category;
    notifyListeners();
  }
}
