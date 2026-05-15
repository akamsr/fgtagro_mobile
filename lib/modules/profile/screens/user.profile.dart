import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
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
                title: Text(isSeller ? 'Tableau de bord Business' : 'Mon Profil', 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor)),
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
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                child: Text(
                                  user?.fullNames?.isNotEmpty == true ? user!.fullNames!.substring(0, 1).toUpperCase() : 'U',
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                ),
                              ),
                              if (isSeller)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                    child: const Icon(Icons.verified, color: Colors.white, size: 20),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isSeller ? (businessState.profile?.storeName ?? "Ma Business") : (user?.fullNames ?? "Utilisateur"),
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

                    // Role Switcher
                    ProfileMenuItem(
                      title: isSeller ? 'Passer en Mode Acheteur' : 'Passer en Mode Vendeur',
                      icon: isSeller ? Icons.shopping_cart_outlined : Icons.storefront,
                      onTap: () => context.read<BusinessCubit>().switchMode(isSeller ? AppMode.buyer : AppMode.seller),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),

                    if (isSeller) ...[
                      ProfileMenuItem(
                        title: 'Profil Business & Logo',
                        icon: Icons.business_outlined,
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        title: 'Vérification & Documents',
                        icon: Icons.assignment_outlined,
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        title: 'Modes de Paiement & Retrait',
                        icon: Icons.account_balance_wallet_outlined,
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        title: 'Statistiques & Performance',
                        icon: Icons.analytics_outlined,
                        onTap: () {},
                      ),
                    ] else ...[
                      ProfileMenuItem(
                        title: 'Mes Commandes',
                        icon: Icons.shopping_bag_outlined,
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        title: 'Adresses de Livraison',
                        icon: Icons.location_on_outlined,
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        title: 'Mes Favoris',
                        icon: Icons.favorite_border,
                        onTap: () => context.router.push(const FavouritesRoute()),
                      ),
                    ],

                    ProfileMenuItem(
                      title: 'Paramètres',
                      icon: Icons.settings_outlined,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      title: 'Aide & Support',
                      icon: Icons.help_outline,
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),

                    // Logout
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Déconnexion', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onTap: () => context.read<AuthCubit>().logout(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: Colors.red.withOpacity(0.05),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

  }
}
