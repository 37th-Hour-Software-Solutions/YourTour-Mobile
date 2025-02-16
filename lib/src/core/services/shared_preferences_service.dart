import 'package:shared_preferences/shared_preferences.dart';

/// A service that provides a wrapper around SharedPreferences for type-safe
/// persistent storage operations.
class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  /// Sets a String value in SharedPreferences.
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Sets a bool value in SharedPreferences.
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Sets an int value in SharedPreferences.
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Sets a double value in SharedPreferences.
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Sets a List<String> value in SharedPreferences.
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Gets a String value from SharedPreferences.
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Gets a bool value from SharedPreferences.
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Gets an int value from SharedPreferences.
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Gets a double value from SharedPreferences.
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Gets a List<String> value from SharedPreferences.
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Removes a value from SharedPreferences.
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Checks if a key exists in SharedPreferences.
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Clears all values from SharedPreferences.
  Future<bool> clear() async {
    return _prefs.clear();
  }
} 