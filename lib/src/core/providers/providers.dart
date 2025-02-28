import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/secure_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/profile/services/profile_service.dart';
import '../../features/profile/models/user.dart';
import '../services/geolocation_service.dart';
import 'package:text_to_speech/text_to_speech.dart';

part 'providers.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(
    baseUrl: 'http://yourtourserv.duckdns.org:3000',  // Replace with your API URL
    contentType: 'application/json',
  ));
}

@riverpod
AuthService authService(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthService(dio, secureStorage);
}

@riverpod
ProfileService profileService(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return ProfileService(dio, secureStorage);
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

@Riverpod(keepAlive: true)
GeolocationService geolocationService(Ref ref) {
  return GeolocationService();
}

@Riverpod(keepAlive: true)
Future<Position?> currentLocation(Ref ref) async {
  final geolocationService = ref.watch(geolocationServiceProvider);
  
  // First try to get the last known position
  final lastPosition = await geolocationService.getLastKnownPosition();
  if (lastPosition != null) {
    return lastPosition;
  }

  try {
    // If no last position, try to get current position
    return await geolocationService.getCurrentPosition();
  } catch (e) {
    return null;
  }
}

@riverpod
TextToSpeech ttsService(Ref ref) {
  return TextToSpeech();
}

@riverpod
class Profile extends _$Profile {
  @override
  FutureOr<User> build() async {
    ref.onDispose(() {}); // Clean up on dispose
    
    final profileService = ref.watch(profileServiceProvider);
    return await profileService.getUser();
  }
}