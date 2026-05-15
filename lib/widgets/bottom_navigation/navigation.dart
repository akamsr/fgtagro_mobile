import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.cubit.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _prevIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.value = 1.0;
  }

  late TabsRouter _tabsRouter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabsRouter = AutoTabsRouter.of(context);
    _tabsRouter.removeListener(_syncIndex);
    _tabsRouter.addListener(_syncIndex);
  }

  void _syncIndex() {
    if (mounted && _tabsRouter.activeIndex != _currentIndex) {
      _handleTabChange(_tabsRouter.activeIndex);
    }
  }

  @override
  void dispose() {
    _tabsRouter.removeListener(_syncIndex);
    _controller.dispose();
    super.dispose();
  }

  void _handleTabChange(int newIndex) {
    if (newIndex != _currentIndex) {
      setState(() {
        _prevIndex = _currentIndex;
        _currentIndex = newIndex;
      });
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, businessState) {
        final isSeller = businessState.isSellerMode;

        return Container(
          decoration: const BoxDecoration(color: AppColors.bgSurface),
          child: SafeArea(
            top: false,
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _NavItem(
                              index: 0,
                              currentIndex: _currentIndex,
                              prevIndex: _prevIndex,
                              progress: _controller,
                              label: isSeller ? s.navDashboard : s.navHome,
                              icon: 'assets/icons/home.svg',
                              onTap: () => _tabsRouter.setActiveIndex(0),
                            ),
                            _NavItem(
                              index: 1,
                              currentIndex: _currentIndex,
                              prevIndex: _prevIndex,
                              progress: _controller,
                              label: isSeller ? s.navProducts : s.navCategories,
                              icon: 'assets/icons/category.svg',
                              onTap: () => _tabsRouter.setActiveIndex(1),
                            ),
                            _NavItem(
                              index: 2,
                              currentIndex: _currentIndex,
                              prevIndex: _prevIndex,
                              progress: _controller,
                              label: isSeller ? s.navOrders : s.navMessages,
                              icon: isSeller
                                  ? 'assets/icons/order.svg'
                                  : 'assets/icons/notification.svg',
                              onTap: () => _tabsRouter.setActiveIndex(2),
                            ),
                            _NavItem(
                              index: 3,
                              currentIndex: _currentIndex,
                              prevIndex: _prevIndex,
                              progress: _controller,
                              label: isSeller ? s.navRentals : s.navOrders,
                              icon: isSeller
                                  ? 'assets/icons/rental.svg'
                                  : 'assets/icons/order.svg',
                              onTap: () => _tabsRouter.setActiveIndex(3),
                            ),
                            _NavItem(
                              index: 4,
                              currentIndex: _currentIndex,
                              prevIndex: _prevIndex,
                              progress: _controller,
                              label: s.navProfile,
                              icon: 'assets/icons/user.svg',
                              onTap: () => _tabsRouter.setActiveIndex(4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final int prevIndex;
  final Animation<double> progress;
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.prevIndex,
    required this.progress,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 60, minHeight: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: AnimatedBuilder(
                animation: progress,
                builder: (context, child) {
                  final t = progress.value;
                  double activeLevel = 0.0;
                  if (index == currentIndex) {
                    activeLevel = progress.isCompleted
                        ? 1.0
                        : Curves.easeIn.transform(
                            (t - 0.4).clamp(0.0, 0.6) / 0.6,
                          );
                  } else if (index == prevIndex) {
                    activeLevel = progress.isCompleted
                        ? 0.0
                        : 1.0 -
                              Curves.easeOut.transform(
                                (t / 0.6).clamp(0.0, 1.0),
                              );
                  }

                  return SvgPicture.asset(
                    icon,
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    colorFilter: ColorFilter.mode(
                      Color.lerp(
                        AppColors.textPrimary,
                        AppColors.primaryColor,
                        activeLevel,
                      )!,
                      BlendMode.srcIn,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            AnimatedBuilder(
              animation: progress,
              builder: (context, child) {
                final isActive = index == currentIndex;
                double visibility = isActive
                    ? Curves.easeOut.transform(progress.value)
                    : 0.6;

                return Opacity(
                  opacity: visibility,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.textPrimary.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
