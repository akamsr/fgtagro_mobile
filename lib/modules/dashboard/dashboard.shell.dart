import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
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
              backgroundColor: AppColors.bgCanvas,
              scrollAuto: false,
              paddingHorizontal: 0,
              extraPadding: false,
              safeAreaTop: false,
              bottomNavigationBar: const CustomBottomNavBar(),
              child: child,
            );
          },
        );
      },
    );
  }
}
