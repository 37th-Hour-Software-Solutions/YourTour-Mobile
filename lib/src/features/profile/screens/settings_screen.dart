import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/auth_middleware.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/providers/providers.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_dropdown_tile.dart';
import '../../../features/auth/providers/auth_provider.dart';

// Add these providers at the top of the file
final darkModeProvider = StateProvider<bool>((ref) => false);
final distanceUnitProvider = StateProvider<String>((ref) => 'mi');
final publicProfileProvider = StateProvider<bool>((ref) => true);
final locationHistoryProvider = StateProvider<bool>((ref) => true);
final nearbyGemsProvider = StateProvider<bool>((ref) => true);
final achievementAlertsProvider = StateProvider<bool>((ref) => true);
final analyticsProvider = StateProvider<bool>((ref) => true);
final offlineMapsProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthMiddleware(
      child: _SettingsContent(),
    );
  }
}

class _SettingsContent extends ConsumerStatefulWidget {
  const _SettingsContent();

  @override
  ConsumerState<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends ConsumerState<_SettingsContent> {
  @override
  void initState() {
    super.initState();
    // Delay initialization to avoid build phase modification
    Future.microtask(() {
      final prefs = ref.read(sharedPreferencesServiceProvider).value;
      if (prefs != null) {
        ref.read(darkModeProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyDarkMode) ?? false;
        ref.read(publicProfileProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyPublicProfile) ?? true;
        ref.read(locationHistoryProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyLocationHistory) ?? true;
        ref.read(nearbyGemsProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyNearbyGems) ?? true;
        ref.read(achievementAlertsProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyAchievementAlerts) ?? true;
        ref.read(analyticsProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyAnalytics) ?? true;
        ref.read(offlineMapsProvider.notifier).state = 
            prefs.getBool(SharedPreferencesService.keyOfflineMaps) ?? false;
        ref.read(distanceUnitProvider.notifier).state = 
            prefs.getString(SharedPreferencesService.keyDistanceUnit) ?? 'mi';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(sharedPreferencesServiceProvider);

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (prefs) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            // App Preferences Section
            _buildSection(
              context,
              title: 'App Preferences',
              children: [
                SettingsToggleTile(
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark theme',
                  value: ref.watch(darkModeProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyDarkMode, value);
                    ref.read(darkModeProvider.notifier).state = value;
                  },
                ),
                SettingsDropdownTile(
                  title: 'Distance Unit',
                  value: ref.watch(distanceUnitProvider),
                  items: const {'km': 'Kilometers', 'mi': 'Miles'},
                  onChanged: (value) async {
                    if (value != null) {
                      await prefs.setString(SharedPreferencesService.keyDistanceUnit, value);
                      ref.read(distanceUnitProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),

            // Privacy Section
            _buildSection(
              context,
              title: 'Privacy',
              children: [
                SettingsToggleTile(
                  title: 'Public Profile',
                  subtitle: 'Let others see your achievements',
                  value: ref.watch(publicProfileProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyPublicProfile, value);
                    ref.read(publicProfileProvider.notifier).state = value;
                  },
                ),
                SettingsToggleTile(
                  title: 'Location History',
                  subtitle: 'Save places you\'ve visited',
                  value: ref.watch(locationHistoryProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyLocationHistory, value);
                    ref.read(locationHistoryProvider.notifier).state = value;
                  },
                ),
              ],
            ),

            // Notifications Section
            _buildSection(
              context,
              title: 'Notifications',
              children: [
                SettingsToggleTile(
                  title: 'Nearby Gems',
                  subtitle: 'Get notified about interesting places nearby',
                  value: ref.watch(nearbyGemsProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyNearbyGems, value);
                    ref.read(nearbyGemsProvider.notifier).state = value;
                  },
                ),
                SettingsToggleTile(
                  title: 'Achievement Alerts',
                  subtitle: 'Get notified when you earn badges',
                  value: ref.watch(achievementAlertsProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyAchievementAlerts, value);
                    ref.read(achievementAlertsProvider.notifier).state = value;
                  },
                ),
              ],
            ),

            // Data & Storage Section
            _buildSection(
              context,
              title: 'Data & Storage',
              children: [
                SettingsToggleTile(
                  title: 'Analytics',
                  subtitle: 'Help us improve your experience',
                  value: ref.watch(analyticsProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyAnalytics, value);
                    ref.read(analyticsProvider.notifier).state = value;
                  },
                ),
                SettingsToggleTile(
                  title: 'Offline Maps',
                  subtitle: 'Download maps for offline use',
                  value: ref.watch(offlineMapsProvider),
                  onChanged: (value) async {
                    await prefs.setBool(SharedPreferencesService.keyOfflineMaps, value);
                    ref.read(offlineMapsProvider.notifier).state = value;
                  },
                ),
              ],
            ),

            // Account Actions Section
            _buildSection(
              context,
              title: 'Account',
              children: [
                ListTile(
                  title: const Text('Clear Cache'),
                  leading: const Icon(Icons.cleaning_services_outlined),
                  onTap: () async {
                    // Clear all preferences except onboarding
                    final hasCompletedOnboarding = prefs.getBool(SharedPreferencesService.keyCompletedOnboarding);
                    await prefs.clear();
                    if (hasCompletedOnboarding != null) {
                      await prefs.setBool(SharedPreferencesService.keyCompletedOnboarding, hasCompletedOnboarding);
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cache cleared')),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onTap: () async {
                    // await prefs.clear();
                    ref.read(authProvider.notifier).logout();
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}