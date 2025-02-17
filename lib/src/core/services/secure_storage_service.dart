import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service that provides a wrapper around SharedPreferences for type-safe
/// persistent storage operations.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  /// Sets a String value in secure storage.
  Future<void> setString(String key, String value) async {
    print('Setting $key to $value');
    return _storage.write(key: key, value: value);
  }

  /// Sets a bool value in secure storage.
  Future<void> setBool(String key, bool value) async {
    print('Setting $key to $value');
    return _storage.write(key: key, value: value.toString());
  }

  /// Sets an int value in secure storage.
  Future<void> setInt(String key, int value) async {
    print('Setting $key to $value');
    return _storage.write(key: key, value: value.toString());
  }

  /// Sets a double value in secure storage.
  Future<void> setDouble(String key, double value) async {
    print('Setting $key to $value');
    return _storage.write(key: key, value: value.toString());
  }

  /// Sets a List value in secure storage.
  Future<void> setStringList(String key, List<String> value) async {
    print('Setting $key to $value');
    return _storage.write(key: key, value: value.join(','));
  }

  /// Gets a String value from secure storage.
  Future<String?> getString(String key) async {
    print('Getting $key');
    return _storage.read(key: key);
  }

  /// Gets a bool value from secure storage.
  Future<bool?> getBool(String key) async {
    print('Getting $key');
    final value = await _storage.read(key: key);
    return value == 'true';
  }

  /// Gets an int value from secure storage.
  Future<int?> getInt(String key) async {
    print('Getting $key');
    final value = await _storage.read(key: key);
    return value != null ? int.parse(value) : null;
  }

  /// Gets a double value from secure storage.
  Future<double?> getDouble(String key) async {
    print('Getting $key');
    final value = await _storage.read(key: key);
    return value != null ? double.parse(value) : null;
  }

  /// Gets a List value from secure storage.
  Future<List<String>?> getStringList(String key) async {
    print('Getting $key');
    final value = await _storage.read(key: key);
    return value?.split(',');
  }

  /// Removes a value from secure storage.
  Future<void> remove(String key) async {
    print('Removing $key');
    return _storage.delete(key: key);
  }

  /// Checks if a key exists in secure storage.
  Future<bool> containsKey(String key) async {
    print('Checking if $key exists');
    return _storage.containsKey(key: key);
  }

  /// Clears all values from secure storage.
  Future<void> clear() async {
    print('Clearing all values');
    return _storage.deleteAll();
  }
} 

