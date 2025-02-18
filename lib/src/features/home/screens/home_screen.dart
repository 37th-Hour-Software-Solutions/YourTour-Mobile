import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/auth_middleware.dart';
import '../widgets/map_section.dart';
import '../widgets/discover_section.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../core/providers/providers.dart';

final homeTabProvider = StateProvider<int>((ref) => 0);

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
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    if (!mounted) return;
    
    final geolocationService = ref.read(geolocationServiceProvider);
    
    try {
      final hasPermission = await geolocationService.requestLocationPermission();
      
      if (mounted) {
        setState(() {
          _isCheckingPermission = false;
        });
      }

      if (!hasPermission && mounted) {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingPermission = false;
        });
      }
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

    // Check if we've already asked for permission
    if (_isCheckingPermission) {
      return const _LocationPermissionRequest();
    }
    
    // Otherwise, we've prompted and they've granted permission
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(key: PageStorageKey('home')),
          Center(
            key: PageStorageKey('search'),
            child: Text('Search coming soon!'),
          ),
          Center(
            key: PageStorageKey('history'),
            child: Text('History'),
          ),
          _ProfileTab(key: PageStorageKey('profile')),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          ref.read(homeTabProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
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
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('YourTour'),
          floating: true,
          automaticallyImplyLeading: false,
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

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(homeTabProvider);
    
    // Refresh profile when tab becomes active
    if (currentTab == 3) {
      ref.invalidate(profileProvider);
    }

    return const ProfileScreen();
  }
}