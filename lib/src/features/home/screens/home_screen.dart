import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/auth_middleware.dart';
import '../widgets/map_section.dart';
import '../widgets/discover_section.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../core/providers/providers.dart';
import '../widgets/location_onboarding.dart';

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

  @override
  Widget build(BuildContext context) {
    return LocationOnboarding(
      child: Scaffold(
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