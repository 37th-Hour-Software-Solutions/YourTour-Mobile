import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class AchievementPopup extends StatefulWidget {
  final String title;
  final String description;
  final String? imagePath;
  final String animationPath;
  final VoidCallback onShare;

  const AchievementPopup({
    super.key,
    required this.title,
    required this.description,
    this.imagePath,
    required this.animationPath,
    required this.onShare,
  });

  @override
  State<AchievementPopup> createState() => _AchievementPopupState();
}

class _AchievementPopupState extends State<AchievementPopup> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _lottieController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40.0,
      ),
    ]).animate(_controller);

    _controller.forward();
    _lottieController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred/darkened background
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        // Centered popup
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        widget.animationPath,
                        height: 200,
                        width: 200,
                        controller: _lottieController,
                        repeat: true,
                        onLoaded: (composition) {
                          _lottieController.duration = composition.duration;
                        },
                      ),
                      if (widget.imagePath != null)
                        Image.asset(
                          widget.imagePath!,
                          height: 120,
                          width: 120,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: widget.onShare,
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 