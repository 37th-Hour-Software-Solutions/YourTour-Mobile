import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../../core/services/secure_storage_service.dart';

class ProfileService {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  ProfileService(this._dio, this._secureStorage);

  Future<User> getUser() async {
    final accessToken = await _secureStorage.getString('accessToken');
    print("got access token" + accessToken.toString());
    
    try {

      print("getting user");
      final response = await _dio.get('/profile', options: Options(headers: {
        'Authorization': accessToken,
      }));

      print(response.data);

      if (response.data['error']) {
        print(response.data['data']['message']);
        throw Exception(response.data['data']['message']);
      }

      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      print("error getting user");
      throw Exception(e.response?.data?['data']['message'] ?? 'Failed to fetch user data');
    }
  }
} 