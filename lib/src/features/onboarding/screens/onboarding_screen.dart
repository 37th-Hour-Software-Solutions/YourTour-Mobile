import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:confetti/confetti.dart';
import '../models/onboarding_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/shared_preferences_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      title: 'Welcome to YourTour',
      subtitle: 'Discover the history around you as you travel',
      lottieAsset: 'assets/animations/map.json',
    ),
    OnboardingItem(
      title: 'Collect Gems',
      subtitle: 'Visit unique cities to collect special gems',
      lottieAsset: 'assets/animations/gem.json',
    ),
    OnboardingItem(
      title: 'Earn Badges',
      subtitle: 'Complete achievements to unlock special badges',
      lottieAsset: 'assets/animations/badge.json',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    if (page == _items.length - 1) {
      _confettiController.play();
    }
  }

  void _completeOnboarding() async {
    final prefs = await ref.read(sharedPreferencesServiceProvider.future);
    await prefs.setBool(SharedPreferencesService.keyCompletedOnboarding, true);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(
                item: _items[index],
                isLastPage: index == _items.length - 1,
                onRegisterTap: () {
                  _completeOnboarding();
                  Navigator.pushNamed(context, '/register');
                },
                onLoginTap: () {
                  _completeOnboarding();
                  Navigator.pushNamed(context, '/login');
                },
              );
            },
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _items.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -3.14 / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 40,
              minBlastForce: 20,
              emissionFrequency: 0.8,
              numberOfParticles: 100,
              gravity: 0.2,
              particleDrag: 0.05,
              colors: const [
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.green,
              ],
              createParticlePath: (size) {
                final path = Path();
                path.addOval(Rect.fromCircle(
                  center: Offset.zero,
                  radius: 3,
                ));
                return path;
              },
              minimumSize: const Size(5, 5),
              maximumSize: const Size(8, 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final bool isLastPage;
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginTap;

  const _OnboardingPage({
    required this.item,
    required this.isLastPage,
    required this.onRegisterTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            item.lottieAsset,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 32),
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (isLastPage) ...[
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onRegisterTap,
                child: const Text('Register'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: onLoginTap,
                child: const Text('Login'),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 