import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/base_provider.dart';

class ThemeProvider extends BaseProvider {
  String _currentTheme;
  bool get isLight => _currentTheme == 'light';

  ThemeProvider() {
    getTheme();
  }

  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentTheme = (prefs.getString('theme') ?? 'light');
    _currentTheme = currentTheme;
    notifyListeners();
  }

  Future<void> changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_currentTheme == 'light') {
      _currentTheme = 'dark';
      await prefs.setString('theme', _currentTheme);
    } else {
      _currentTheme = 'light';
      await prefs.setString('theme', _currentTheme);
    }
    notifyListeners();
  }
}
