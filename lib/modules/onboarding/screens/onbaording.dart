import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/modules/onboarding/cubit/onbaording.cubit.dart';
import 'package:fgtagro_mobile/modules/onboarding/cubit/onboarding.state.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _hintController;
  late final Animation<double> _hintAnimation;
  Timer? _timer;
  int _currentPage = 0;
  double _dragValue = 0;
  bool _isDragging = false;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/onboarding/image_1.png',
      'title': 'Your market,\nright in\nyour pocket',
      'description': 'Fresh groceries delivered to your door.',
    },
    {
      'image': 'assets/onboarding/image_2.png',
      'title': 'Farm-fresh\nproduce, every\nsingle time',
      'description': 'Sourced directly from local farmers.',
    },
    {
      'image': 'assets/onboarding/image_3.png',
      'title': 'Great prices,\nno corners\ncut',
      'description': 'Daily deals and offers, every week.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _hintAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 4500), (timer) {
      if (_currentPage < _onboardingData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state.isCompleted) {
            CustomNavigate.replaceAll([const RegisterRoute()]);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                // Animated Background Image
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      context.read<OnboardingCubit>().setPage(index);
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Transform.scale(
                          scale: 1.0, // Zoom effect
                          child: Image.asset(
                            _onboardingData[index]['image']!,
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/logo.jpeg',
                                  width: 40,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'FGT AGRO',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: List.generate(_onboardingData.length, (
                                index,
                              ) {
                                final isActive = _currentPage == index;
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  margin: EdgeInsets.only(left: 6),
                                  width: isActive ? 40 : 8,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.primaryColor
                                        : AppColors.primaryColor.withOpacity(
                                            0.3,
                                          ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                            child: Column(
                              key: ValueKey<int>(_currentPage),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _onboardingData[_currentPage]['title']!,
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryColor,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _onboardingData[_currentPage]['description']!,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.secondaryColor.withOpacity(
                                      0.8,
                                    ),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Subtle Swipable "Slide to Begin" Button
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double maxDragWidth =
                                    constraints.maxWidth - 64;
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Background Text
                                    Text(
                                      'Slide to begin',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor
                                            .withOpacity(0.5),
                                      ),
                                    ),

                                    // Sliding Knob
                                    AnimatedBuilder(
                                      animation: _hintAnimation,
                                      builder: (context, child) {
                                        return Positioned(
                                          left: _isDragging
                                              ? _dragValue
                                              : _hintAnimation.value,
                                          child: GestureDetector(
                                            onPanStart: (_) {
                                              setState(() {
                                                _isDragging = true;
                                                _dragValue =
                                                    _hintAnimation.value;
                                              });
                                              _hintController.stop();
                                            },
                                            onPanUpdate: (details) {
                                              setState(() {
                                                _dragValue =
                                                    (_dragValue +
                                                            details.delta.dx)
                                                        .clamp(
                                                          0.0,
                                                          maxDragWidth,
                                                        );
                                              });
                                            },
                                            onPanEnd: (details) {
                                              if (_dragValue >
                                                  maxDragWidth * 0.8) {
                                                context
                                                    .read<OnboardingCubit>()
                                                    .completeOnboarding();
                                              } else {
                                                setState(() {
                                                  _isDragging = false;
                                                  _dragValue = 0;
                                                });
                                                _hintController.repeat(
                                                  reverse: true,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 64,
                                              height: 64,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.double_arrow,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
