import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/edit_profile_form.dart';
import '../../../core/widgets/auth_middleware.dart';

class EditProfileScreen extends ConsumerWidget {
  static const routeName = '/edit_profile';

  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AuthMiddleware(
      child: _EditProfileContent(),
    );
  }
}

class _EditProfileContent extends ConsumerWidget {
  const _EditProfileContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EditProfileForm(),
        ),
      ),
    );
  }
} 