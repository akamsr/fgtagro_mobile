import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerProfileView extends StatelessWidget {
  final UserModel? user;

  const BuyerProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Note: Wrapping in RefreshIndicator for pull-to-refresh
    return RefreshIndicator(
      onRefresh: () async {
        // Fetch profile data here
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            if (_isProfileIncomplete()) _buildCompletionBanner(context),
            const SizedBox(height: 24),
            _buildQuickStats(context),
            const SizedBox(height: 32),
            _buildMenuGroups(context),
            const SizedBox(height: 100), // padding at bottom
          ],
        ),
      ),
    );
  }

  bool _isProfileIncomplete() {
    return user?.fullNames?.isEmpty ?? true; // Add real logic here
  }

  Widget _buildHeader(BuildContext context) {
    final bool phoneVerified = true; // Mock status
    final bool emailVerified = false; // Mock status

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Show bottom sheet to view/change photo
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    user?.fullNames?.isNotEmpty == true
                        ? user!.fullNames!.substring(0, 1).toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            user?.fullNames ?? S.of(context).userLabel,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            context.router.push(
                              const PersonalInformationRoute(),
                            );
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phoneNumber ?? 'No phone number',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.email ?? 'No email address',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Verification Badges
                    Row(
                      children: [
                        _buildVerificationBadge(
                          isVerified: phoneVerified,
                          verifiedText: 'Phone verified',
                          unverifiedText: 'Phone not verified',
                        ),
                        const SizedBox(width: 8),
                        _buildVerificationBadge(
                          isVerified: emailVerified,
                          verifiedText: 'Email verified',
                          unverifiedText: 'Email not verified',
                          onVerify: () {
                            context.router.push(VerifyEmailRoute());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge({
    required bool isVerified,
    required String verifiedText,
    required String unverifiedText,
    VoidCallback? onVerify,
  }) {
    if (isVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.check, size: 10, color: Colors.green),
            const SizedBox(width: 2),
            Text(
              verifiedText,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: onVerify,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 10,
                color: Colors.orange,
              ),
              const SizedBox(width: 2),
              Text(
                unverifiedText,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCompletionBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Complete your profile for a better experience',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.secondaryColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Dismiss banner
                },
                child: const Icon(Icons.close, size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '60%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.router.push(const PersonalInformationRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Complete now',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatChip(
              context,
              Icons.shopping_bag_outlined,
              'Orders',
              '12',
              () {
                AutoTabsRouter.of(context).setActiveIndex(3);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatChip(
              context,
              Icons.favorite_border,
              'Favourites',
              '14',
              () => context.router.push(const FavouritesRoute()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatChip(
              context,
              Icons.location_on_outlined,
              'Addresses',
              '2',
              () {
                context.router.push(const MyAddressesRoute());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String label,
    String count,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroups(BuildContext context) {
    return Column(
      children: [
        _buildMenuGroup(
          title: 'Account',
          children: [
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () =>
                  context.router.push(const PersonalInformationRoute()),
            ),
            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'My Addresses',
              onTap: () => context.router.push(const MyAddressesRoute()),
            ),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'My Favourites',
              badgeText: '14',
              onTap: () => context.router.push(const FavouritesRoute()),
            ),
            _buildMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              badgeText: '2 Active',
              onTap: () => AutoTabsRouter.of(context).setActiveIndex(3),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildMenuGroup(
          title: 'Preferences',
          children: [
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notification Preferences',
              onTap: () =>
                  context.router.push(const NotificationPreferencesRoute()),
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: 'Language',
              trailingText: 'English',
              onTap: () => context.router.push(const LanguageSettingsRoute()),
            ),
          ],
        ),
        const SizedBox(height: 24),
        BlocBuilder<BusinessCubit, BusinessState>(
          builder: (context, state) {
            final isSellerValidated =
                state.profile != null && state.profile!.status == 'VALIDATED';
            return _buildMenuGroup(
              title: 'Seller',
              children: [
                if (isSellerValidated)
                  _buildMenuItem(
                    icon: Icons.storefront,
                    title: 'Switch to Seller Mode',
                    onTap: () => context.read<BusinessCubit>().switchMode(
                      AppMode.seller,
                    ),
                  )
                else
                  _buildMenuItem(
                    icon: Icons.storefront,
                    title: 'Become a Seller',
                    onTap: () =>
                        context.router.push(const SellerOnboardRoute()),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildMenuGroup(
          title: 'Support & Legal',
          children: [
            _buildMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Support',
              onTap: () => context.router.push(const ContactSupportRoute()),
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms and Conditions',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About FGT AGRO',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildMenuGroup(
          children: [
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log Out',
              isDestructive: true,
              showChevron: false,
              onTap: () => _showLogoutConfirmation(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuGroup({String? title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badgeText,
    String? trailingText,
    bool isDestructive = false,
    bool showChevron = true,
  }) {
    final color = isDestructive ? Colors.red : AppColors.secondaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (badgeText != null || trailingText != null)
              const SizedBox(width: 8),
            if (showChevron)
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?'),
        content: const Text(
          'You will need to log back in to access your orders, favourites, and rentals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
  }
}
