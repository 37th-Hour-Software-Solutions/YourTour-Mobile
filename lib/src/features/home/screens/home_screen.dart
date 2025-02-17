import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/auth_middleware.dart';
import '../../../core/services/geolocation_service.dart';
import '../widgets/map_section.dart';
import '../widgets/discover_section.dart';
import '../../../features/profile/screens/profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AuthMiddleware(
      child: _HomeContent(),
    );
  }
}

class _HomeContent extends ConsumerStatefulWidget {
  const _HomeContent();

  @override
  ConsumerState<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<_HomeContent> {
  int _currentIndex = 0;
  bool _hasCheckedPermission = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final geolocationService = ref.read(geolocationServiceProvider);
    final hasPermission = await geolocationService.requestLocationPermission();
    
    if (!mounted) return;
    setState(() => _hasCheckedPermission = true);

    if (!hasPermission) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LocationPermissionDialog(
        onRetry: () {
          Navigator.pop(context);
          _checkLocationPermission();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCheckedPermission) {
      return const _LocationPermissionRequest();
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _buildCurrentTab(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return const _HomeTab();
      case 1:
        return const Center(child: Text('History'));
      case 2:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('YourTour'),
          floating: true,
        ),
        SliverToBoxAdapter(
          child: MapSection(),
        ),
        DiscoverSection(),
      ],
    );
  }
}

class _LocationPermissionRequest extends StatelessWidget {
  const _LocationPermissionRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                "Let's Get Started!",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "We'll need access to your location to guide you on your journey.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPermissionDialog extends ConsumerWidget {
  final VoidCallback onRetry;

  const _LocationPermissionDialog({required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.orange),
          const SizedBox(width: 8),
          const Text('Location Access Needed'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "How are we supposed to guide you if we don't know where you are? 🤔",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "We promise to only use your location to provide directions and find interesting places nearby!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final geolocationService = ref.read(geolocationServiceProvider);
            await geolocationService.openLocationSettings();
          },
          child: const Text('Open Settings'),
        ),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Try Again'),
        ),
      ],
    );
  }
} 