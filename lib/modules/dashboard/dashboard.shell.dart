import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/routes/router.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:fgtagro_mobile/widgets/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeDashBoardPage extends StatelessWidget {
  const HomeDashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (_, provider, __) {
        return AutoTabsRouter(
          homeIndex: 0,
          routes: [
            const DashboardHomeRoute(),
            const CategoriesRoute(),
            const ConversationListRoute(),
            const OrdersRoute(),
            const ProfileRoute(),
          ],
          builder: (ctx, child) {
            provider.init(ctx);
            return DefaultScreen(
              backgroundColor: AppColors.primaryColor,
              scrollAuto: false,
              paddingHorizontal: 0,
              extraPadding: false,
              safeAreaTop: false,
              bottomNavigationBar: Consumer<BottomNavProvider>(
                builder: (_, provider, __) {
                  return AnimatedSlide(
                    offset: provider.showNavbar
                        ? Offset.zero
                        : const Offset(0, 1),
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: provider.showNavbar ? 1.0 : 0.0,
                      child: const CustomBottomNavBar(),
                    ),
                  );
                },
              ),
              child: Stack(
                children: [
                  child,
                  // Placeholder for AppLockScreen
                  // if (isLocked) const AppLockScreen(),

                  // Placeholder for AgroBotFAB
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        // TODO: Open AgroBot
                      },
                      child: const Icon(Icons.smart_toy),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool safeAreaTop() {
    log(locator<AppRouter>().currentUrl.split('/').last);
    switch (locator<AppRouter>().currentUrl.split('/').last) {
      case 'profile-dashboard':
        return false;
      case 'supermarket-business-route':
        return false;
      case 'manage-business-route':
        return false;
      case 'shopping-route':
        return false;
      default:
        return true;
    }
  }
}
