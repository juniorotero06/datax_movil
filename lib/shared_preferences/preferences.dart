import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _pref;

  static String _name = "";
  static bool _isDarkmode = false;
  static int _gender = 1;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static String get name {
    return _pref.getString("name") ?? _name;
  }

  static set name(String name) {
    _name = name;
    _pref.setString("name", name);
  }

  static bool get isDarkmode {
    return _pref.getBool("isDarkmode") ?? _isDarkmode;
  }

  static set isDarkmode(bool value) {
    _isDarkmode = value;
    _pref.setBool("isDarkmode", value);
  }

  static int get gender {
    return _pref.getInt("gender") ?? _gender;
  }

  static set gender(int gender) {
    _gender = gender;
    _pref.setInt("gender", gender);
  }
}
