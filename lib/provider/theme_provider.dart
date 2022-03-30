import 'package:flutter/material.dart';

import 'package:datax_movil/themes/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({required bool isDarkmode})
      : currentTheme = isDarkmode ? ThemeData.dark() : AppTheme.lightTheme;

  setLightMode() {
    currentTheme = AppTheme.lightTheme;
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark();
    notifyListeners();
  }
}
