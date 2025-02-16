import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

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

      print("success");
      print(response.data['data']['accessToken']);
      print(response.data['data']['refreshToken']);
      
      return {
        'accessToken': response.data['data']['accessToken'],
        'refreshToken': response.data['data']['refreshToken'],
      };
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
} 