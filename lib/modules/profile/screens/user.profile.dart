import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/profile/widgets/profile_menu_item.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
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
                          user?.fullNames?.isNotEmpty == true ? user!.fullNames!.substring(0, 1).toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.fullNames ?? "Utilisateur",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
                      ),
                      Text(
                        user?.email ?? user?.phoneNumber ?? "",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Menu Items
                ProfileMenuItem(
                  title: 'Espace Vendeur',
                  icon: Icons.storefront,
                  onTap: () => context.router.push(const SellerDashboardRoute()),
                ),
                ProfileMenuItem(
                  title: 'Mes Commandes',
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    // TODO: Navigate to orders
                  },
                ),
                ProfileMenuItem(
                  title: 'Paramètres',
                  icon: Icons.settings_outlined,
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                ProfileMenuItem(
                  title: 'Aide & Support',
                  icon: Icons.help_outline,
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                const SizedBox(height: 24),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Déconnexion', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.red.withOpacity(0.05),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
