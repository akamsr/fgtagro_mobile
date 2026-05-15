import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/dashboard_menu_item.dart';
import 'package:fgtagro_mobile/modules/dashboard/widgets/dashboard_profile_stat.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fgtagro_mobile/widgets/locale/locale_provider.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock Data
  final bool isAuthenticated = true;
  final bool hasSellerProfile = false;
  final bool canUseBiometric = true;
  bool isBiometricEnabled = false;

  final String firstName = 'Jean';
  final String lastName = 'Mbala';
  final String email = 'jean.mbala@example.com';
  final String initials = 'JM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── En-tête profil ───
              Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 28,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: isAuthenticated
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$firstName $lastName',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.secondaryColor,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      S.of(context).editProfile,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.secondaryColor,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              S.of(context).visitor,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              if (isAuthenticated)
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardProfileStat(
                          value: '23',
                          label: S.of(context).orders,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DashboardProfileStat(
                          value: '8',
                          label: S.of(context).reviews,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DashboardProfileStat(
                          value: '5',
                          label: S.of(context).favorites,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ),

              if (isAuthenticated)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EE),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.storefront,
                              size: 22,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasSellerProfile
                                      ? S.of(context).sellerSpace
                                      : S.of(context).becomeSeller,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  hasSellerProfile
                                      ? 'AGRO DISTRIB SARL'
                                      : S.of(context).sellYourProducts,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ─── Paramètres du compte ───
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12, left: 4),
                      child: Text(
                        S.of(context).myAccount,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black38,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          DashboardMenuItem(
                            icon: Icons.location_on_outlined,
                            label: S.of(context).addresses,
                            onTap: () {},
                          ),
                          DashboardMenuItem(
                            icon: Icons.payment_outlined,
                            label: S.of(context).paymentMethod,
                            divider: true,
                            onTap: () {},
                          ),
                          DashboardMenuItem(
                            icon: Icons.notifications_outlined,
                            label: S.of(context).notifications,
                            divider: true,
                            onTap: () {},
                          ),

                          // Biometric toggle
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color.fromRGBO(197, 198, 208, 0.5),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      235,
                                      105,
                                      9,
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.fingerprint,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).biometricLogin,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                      if (!canUseBiometric)
                                        const Text(
                                          'Non configurée sur cet appareil',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (canUseBiometric)
                                  Switch(
                                    value: isBiometricEnabled,
                                    onChanged: (v) =>
                                        setState(() => isBiometricEnabled = v),
                                    activeColor: AppColors.primaryColor,
                                  ),
                              ],
                            ),
                          ),

                          DashboardMenuItem(
                            icon: Icons.receipt_long_outlined,
                            label: S.of(context).myOrders,
                            divider: true,
                            onTap: () {},
                          ),

                          DashboardMenuItem(
                            icon: Icons.language,
                            label: S.of(context).language,
                            divider: true,
                            onTap: () => context.router.push(const LanguageSettingsRoute()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Support ───
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12, left: 4),
                      child: Text(
                        S.of(context).helpAndSupport,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black38,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          DashboardMenuItem(
                            icon: Icons.help_outline,
                            label: S.of(context).helpCenter,
                            onTap: () {},
                          ),

                          // Logout
                          DashboardMenuItem(
                            icon: Icons.logout,
                            label: S.of(context).logout,
                            divider: true,
                            onTap: () {},
                            iconBgColor: const Color.fromRGBO(239, 68, 68, 0.1),
                            iconColor: Colors.red,
                            textColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
