import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/modules/profile/widgets/profile_menu_item.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/modules/profile/screens/seller_profile_view.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, businessState) {
        final isSeller = businessState.appMode == AppMode.seller;

        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.user == null) {
              context.router.replaceAll([const LoginRoute()]);
            }
          },
          builder: (context, state) {
            final user = state.user;

            return Scaffold(
              backgroundColor: const Color(0xFFFBF8FD),
              appBar: AppBar(
                title: Text(
                  isSeller
                      ? S.of(context).businessDashboard
                      : S.of(context).myProfile,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              body: isSeller
                  ? SellerProfileView(user: user)
                  : _buildBuyerProfile(context, user),
            );
          },
        );
      },
    );
  }

  Widget _buildBuyerProfile(BuildContext context, UserModel? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    user?.fullNames?.isNotEmpty == true
                        ? user!.fullNames!.substring(0, 1).toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.fullNames ?? S.of(context).userLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  user?.email ?? user?.phoneNumber ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Role Switcher
          ProfileMenuItem(
            title: S.of(context).switchToSellerMode,
            icon: Icons.storefront,
            onTap: () =>
                context.read<BusinessCubit>().switchMode(AppMode.seller),
          ),
          const Divider(),
          const SizedBox(height: 8),

          ProfileMenuItem(
            title: S.of(context).myOrders,
            icon: Icons.shopping_bag_outlined,
            onTap: () {},
          ),
          ProfileMenuItem(
            title: S.of(context).shippingAddresses,
            icon: Icons.location_on_outlined,
            onTap: () {},
          ),
          ProfileMenuItem(
            title: S.of(context).favorites,
            icon: Icons.favorite_border,
            onTap: () => context.router.push(const FavouritesRoute()),
          ),

          ProfileMenuItem(
            title: S.of(context).settings,
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
          ProfileMenuItem(
            title: S.of(context).helpSupport,
            icon: Icons.help_outline,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              S.of(context).deconnexion,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text('Log out of FGT AGRO?'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthCubit>().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.red.withOpacity(0.05),
          ),
        ],
      ),
    );
  }
}
