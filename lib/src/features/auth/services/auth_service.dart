import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../../core/services/secure_storage_service.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  AuthService(this._dio, this._secureStorage);

  Future<void> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/auth/register', data: request.toJson());
      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Registration failed');
    }
  }

  Future<Map<String, String>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/auth/login', data: request.toJson());
      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }

      print("login success");
      print(response.data['data']['accessToken']);
      print(response.data['data']['refreshToken']);
      
      final tokens = {
        'accessToken': response.data['data']['accessToken'].toString(),
        'refreshToken': response.data['data']['refreshToken'].toString(),
      };

      await _secureStorage.setString('accessToken', tokens['accessToken']!);
      await _secureStorage.setString('refreshToken', tokens['refreshToken']!);

      return tokens;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Login failed');
    }
  }

  Future<void> verifyToken(String token) async {
    try {
      final response = await _dio.post('/auth/verify', data: {'accessToken': token});
      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Token verification failed');
    }
  }

  Future<String> refreshToken(String token) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {'refreshToken': token});
      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }

      print("refresh success");
      print(response.data['data']['accessToken']);
      return response.data['data']['accessToken'];
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Token refresh failed');
    }
  }
} 