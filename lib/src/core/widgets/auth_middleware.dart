import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';

class AuthMiddleware extends ConsumerStatefulWidget {
  final Widget child;

  const AuthMiddleware({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthMiddleware> createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends ConsumerState<AuthMiddleware> {
  @override
  void initState() {
    super.initState();
    // Only refresh once when the middleware is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authProvider).when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        });
        return const SizedBox.shrink();
      },
      data: (isAuthenticated) {
        if (!isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
          return const SizedBox.shrink();
        }
        return widget.child;
      },
    );
  }
} 