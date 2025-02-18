import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/providers.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<bool> build() async {
    return _checkAuth();
  }

  Future<bool> _checkAuth() async {
    final storage = ref.read(secureStorageServiceProvider);
    final token = await storage.getString('accessToken');
    if (token == null) return false;

    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyToken(token);
      return true;
    } catch (e) {
      await storage.remove('accessToken');
      await storage.remove('refreshToken');
      return false;
    }
  }

  Future<void> login(String accessToken, String refreshToken) async {
    final storage = ref.read(secureStorageServiceProvider);
    await storage.setString('accessToken', accessToken);
    await storage.setString('refreshToken', refreshToken);
    state = const AsyncValue.data(true);
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageServiceProvider);
    await storage.remove('accessToken');
    await storage.remove('refreshToken');
    state = const AsyncValue.data(false);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _checkAuth());
  }
} 