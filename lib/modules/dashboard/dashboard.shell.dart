import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
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
                      const ProductListRoute(), // Placeholder for Products
                      const OrdersRoute(), // Placeholder for Orders
                      const CategoriesRoute(), // Placeholder for Rentals
                      const ProfileRoute(),
                    ]
                  : [
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
                  child: Column(
                    children: [
                      if (isSeller)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          color: AppColors.primaryColor.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.storefront,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'You are in Seller Mode',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    context.read<BusinessCubit>().toggleMode(),
                                child: const Text(
                                  'Switch back',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(child: child),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
