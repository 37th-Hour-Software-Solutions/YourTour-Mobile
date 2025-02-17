import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../../core/services/secure_storage_service.dart';

class ProfileService {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  ProfileService(this._dio, this._secureStorage);

  Future<User> getUser() async {
    final accessToken = await _secureStorage.getString('accessToken');
    
    try {
      final response = await _dio.get('/profile', options: Options(headers: {
        'Authorization': accessToken,
      }));

      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }

      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Failed to fetch user data');
    }
  }

  Future<void> updateUser(User user, String password, String oldPassword) async {
    final accessToken = await _secureStorage.getString('accessToken');

    try {
      final response = await _dio.post('/profile/update', data: user.toJson(password, oldPassword), options: Options(headers: {
        'Authorization': accessToken,
      }));

      if (response.data['error']) {
        throw Exception(response.data['data']['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['data']['message'] ?? 'Failed to update user data');
    }
  }
} 