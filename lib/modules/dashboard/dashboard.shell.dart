import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/modules/business/widgets/seller_gate.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:fgtagro_mobile/widgets/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeDashBoardPage extends StatelessWidget {
  const HomeDashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, businessState) {
        final isSeller = businessState.isSellerMode;

        return Consumer<BottomNavProvider>(
          builder: (_, provider, __) {
            return AutoTabsRouter(
              homeIndex: 0,
              routes: isSeller
                  ? [
                      const SellerDashboardRoute(),
                      const SellerProductListRoute(),
                      const SellerOrderListRoute(),
                      const SellerRentalListRoute(),
                      const ProfileRoute(),
                    ]
                  : [
                      const DashboardHomeRoute(),
                      const CategoriesRoute(),
                      const OrdersRoute(),
                      const RentalMainRoute(),
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
                  child: isSeller ? SellerGate(child: child) : child,
                );
              },
            );
          },
        );
      },
    );
  }
}
