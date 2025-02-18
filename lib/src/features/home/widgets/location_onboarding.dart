import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';

class LocationOnboarding extends ConsumerStatefulWidget {
  final Widget child;

  const LocationOnboarding({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<LocationOnboarding> createState() => _LocationOnboardingState();
}

class _LocationOnboardingState extends ConsumerState<LocationOnboarding> {
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
    if (_isCheckingPermission) {
      return const _LocationPermissionRequest();
    }
    
    return widget.child;
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
          const Icon(Icons.location_off, color: Colors.red),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Location Access Needed',
              softWrap: true,
            ),
          ),
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
            "Your location is used to provide directions and find interesting places nearby.",
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