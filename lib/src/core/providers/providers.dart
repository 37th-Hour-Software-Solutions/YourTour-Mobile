import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/secure_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../features/auth/services/auth_service.dart';

part 'providers.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:3000',  // Replace with your API URL
    contentType: 'application/json',
  ));
}

@riverpod
AuthService authService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
Future<SharedPreferencesService> sharedPreferencesService(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SharedPreferencesService(prefs);
}

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return SecureStorageService(storage);
}
