import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward().whenComplete(() {
      setState(() {
        _showLoader = true;
      });
      _navigateToNext();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    // Wait for 5 seconds total (including animation time)
    await Future.delayed(const Duration(seconds: 5));

    final storage = locator<StorageServices>();
    final bool isFirstTime = storage.readData('isFirstTime') ?? true;
    final bool isLoggedIn = storage.readData('token') != null;

    if (isFirstTime) {
      CustomNavigate.replaceAll([const OnboardingRoute()]);
    } else if (isLoggedIn) {
      CustomNavigate.replaceAll([const HomeDashBoardRoute()]);
    } else {
      CustomNavigate.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset('assets/icons/logo.jpeg', width: 200),
              ),
            ),
          ),
          if (_showLoader)
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(child: WindowsLoader()),
            ),
        ],
      ),
    );
  }
}

class WindowsLoader extends StatefulWidget {
  const WindowsLoader({Key? key}) : super(key: key);

  @override
  State<WindowsLoader> createState() => _WindowsLoaderState();
}

class _WindowsLoaderState extends State<WindowsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: List.generate(6, (index) {
              // Calculate a continuous progress for each dot
              final double offset = index * 0.12;
              final double progress = (_controller.value - offset) % 1.0;

              // Use a curve that provides variable speed (faster at top, slower at bottom)
              // to mimic the Windows "chase" effect while staying continuous.
              final double rotation =
                  Curves.easeInOutSine.transform(progress) * 2 * 3.14159;

              // Add a slight opacity fade at the end of the cycle for smoother transitions
              final double opacity = progress < 0.1
                  ? progress * 10
                  : (progress > 0.9 ? (1.0 - progress) * 10 : 1.0);

              return Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: rotation,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
