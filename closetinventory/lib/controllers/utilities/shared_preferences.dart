import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static SharedPreferences? getInstance() {
    return _prefsInstance;
  }

  static bool isInitialized() {
    return _prefsInstance != null;
  }

  static Future<bool> isKeyExists(String key) async {
    var prefs = await _instance;
    return prefs.containsKey(key);
  }

  // CREATE FUNCTIONS

  // READ FUNCTIONS
  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static bool getHasOnboarded() {
    return getString(CONSTANTS.isOnboarded).toLowerCase() == 'true';
  }

  // UPDATE FUNCTIONS
  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setHasOnboarded(bool value) async {
    return setString(CONSTANTS.isOnboarded, value.toString());
  }

  // DELETE FUNCTIONS
  static clearAllPrefs() {
    clearAll();
  }

  static Future<bool> clearAll() async {
    var prefs = await _instance;
    return prefs.clear();
  }
}
