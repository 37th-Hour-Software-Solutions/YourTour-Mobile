import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/providers/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesServiceProvider);

    return prefsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading app: $error')),
      ),
      data: (prefs) {
        print(prefs.getBool(SharedPreferencesService.keyCompletedOnboarding));
        final completedOnboarding = prefs.getBool(SharedPreferencesService.keyCompletedOnboarding) ?? false;
        final initialRoute = completedOnboarding ? "/home" : "/onboarding";

        // Replace SplashScreen with the actual initial screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(initialRoute);
        });

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}