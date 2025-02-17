import 'package:shared_preferences/shared_preferences.dart';

/// A service that provides a wrapper around SharedPreferences for type-safe
/// persistent storage operations.
class SharedPreferencesService {
  final SharedPreferences _prefs;

  // Add setting keys
  static const String keyCompletedOnboarding = 'completed_onboarding';
  static const String keyDarkMode = 'dark_mode';
  static const String keyDistanceUnit = 'distance_unit';
  static const String keyPublicProfile = 'public_profile';
  static const String keyLocationHistory = 'location_history';
  static const String keyNearbyGems = 'nearby_gems';
  static const String keyAchievementAlerts = 'achievement_alerts';
  static const String keyAnalytics = 'analytics';
  static const String keyOfflineMaps = 'offline_maps';

  SharedPreferencesService(this._prefs);

  /// Sets a String value in SharedPreferences.
  Future<bool> setString(String key, String value) async {
    print('Setting $key to $value');
    return _prefs.setString(key, value);
  }

  /// Sets a bool value in SharedPreferences.
  Future<bool> setBool(String key, bool value) async {
    print('Setting $key to $value');
    return _prefs.setBool(key, value);
  }

  /// Sets an int value in SharedPreferences.
  Future<bool> setInt(String key, int value) async {
    print('Setting $key to $value');
    return _prefs.setInt(key, value);
  }

  /// Sets a double value in SharedPreferences.
  Future<bool> setDouble(String key, double value) async {
    print('Setting $key to $value');
    return _prefs.setDouble(key, value);
  }

  /// Sets a List<String> value in SharedPreferences.
  Future<bool> setStringList(String key, List<String> value) async {
    print('Setting $key to $value');
    return _prefs.setStringList(key, value);
  }

  /// Gets a String value from SharedPreferences.
  String? getString(String key) {
    print('Getting $key');
    return _prefs.getString(key);
  }

  /// Gets a bool value from SharedPreferences.
  bool? getBool(String key) {
    print('Getting $key');
    return _prefs.getBool(key);
  }

  /// Gets an int value from SharedPreferences.
  int? getInt(String key) {
    print('Getting $key');
    return _prefs.getInt(key);
  }

  /// Gets a double value from SharedPreferences.
  double? getDouble(String key) {
    print('Getting $key');
    return _prefs.getDouble(key);
  }

  /// Gets a List<String> value from SharedPreferences.
  List<String>? getStringList(String key) {
    print('Getting $key');
    return _prefs.getStringList(key);
  }

  /// Removes a value from SharedPreferences.
  Future<bool> remove(String key) async {
    print('Removing $key');
    return _prefs.remove(key);
  }

  /// Checks if a key exists in SharedPreferences.
  bool containsKey(String key) {
    print('Checking if $key exists');
    return _prefs.containsKey(key);
  }

  /// Clears all values from SharedPreferences.
  Future<bool> clear() async {
    print('Clearing all values');
    return _prefs.clear();
  }
} 