import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerProfileView extends StatelessWidget {
  final UserModel? user;

  const SellerProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildAccountSection(context),
          const SizedBox(height: 24),
          _buildDocumentsSection(context),
          const SizedBox(height: 24),
          _buildBankAndPayoutSection(context),
          const SizedBox(height: 24),
          _buildNotificationPreferences(context),
          const SizedBox(height: 24),
          _buildSupportAndLegal(context),
          const SizedBox(height: 32),
          _buildSwitchModeButton(context),
          const SizedBox(height: 16),
          _buildLogoutButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Text(
                  user?.fullNames?.isNotEmpty == true
                      ? user!.fullNames!.substring(0, 1).toUpperCase()
                      : 'B',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user?.fullNames ?? 'GIA Store',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              ' (124 reviews)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Trust Level Badge
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.grey,
                        size: 24,
                      ), // Silver color
                      SizedBox(width: 8),
                      Text(
                        'Silver Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Level 2',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              const Text(
                '23 more sales to reach Gold',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Profile Completion
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile Completion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Text(
                    '80%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your certifications to reach 100%',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _SectionCard(
      title: 'Account Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoRow(
          'Full Name',
          user?.fullNames ?? 'John Doe',
          isEditable: false,
        ),
        const Divider(height: 1),
        _buildInfoRow(
          'Phone',
          user?.phoneNumber ?? '+237 600000000',
          isEditable: false,
          hint: 'Contact support to change',
        ),
        const Divider(height: 1),
        _buildInfoRow(
          'Email',
          user?.email ?? 'john@example.com',
          isEditable: true,
        ),
        const Divider(height: 1),
        _buildInfoRow('Business Name', 'FGT Agro Farm', isEditable: true),
        const Divider(height: 1),
        _buildInfoRow(
          'Activity Types',
          'Farming, Processing',
          isEditable: true,
        ),
        const Divider(height: 1),
        _buildInfoRow(
          'Business Address',
          'Bafoussam, West Region',
          isEditable: true,
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    return _SectionCard(
      title: 'Verification Documents',
      icon: Icons.assignment_outlined,
      children: [
        _buildDocRow('ID Card (Front)', 'Verified', Colors.green),
        const Divider(height: 1),
        _buildDocRow('ID Card (Back)', 'Verified', Colors.green),
        const Divider(height: 1),
        _buildDocRow('Selfie', 'Pending', Colors.orange),
        const Divider(height: 1),
        _buildDocRow('RCCM', 'Not provided', Colors.grey, action: 'Upload'),
      ],
    );
  }

  Widget _buildBankAndPayoutSection(BuildContext context) {
    return _SectionCard(
      title: 'Bank & Payout Settings',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.phone_android, color: Colors.orange),
          ),
          title: const Text(
            'Orange Money',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('+237 690 000 000'),
          trailing: OutlinedButton(
            onPressed: () {
              // Open edit payout details form
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Payout detail changes require admin verification and take effect within 24 hours.',
                  style: TextStyle(color: Colors.blue, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Payout History',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Open payout history screen
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Pending Payouts',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('3 orders in escrow'),
          trailing: const Text(
            '124,500 FCFA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 16,
            ),
          ),
          onTap: () {
            // Open pending payouts screen
          },
        ),
      ],
    );
  }

  Widget _buildNotificationPreferences(BuildContext context) {
    return _SectionCard(
      title: 'Notification Preferences',
      icon: Icons.notifications_outlined,
      children: [
        _buildToggleRow('New order received', 'Push + SMS', true),
        _buildToggleRow('Order delivered', 'Push + SMS', true),
        _buildToggleRow('Payout completed', 'Push + Email', true),
        _buildToggleRow('Product approved/rejected', 'Push + Email', true),
        _buildToggleRow(
          'Quiet Hours (10pm - 7am)',
          'Mutes non-critical alerts',
          false,
        ),
      ],
    );
  }

  Widget _buildSupportAndLegal(BuildContext context) {
    return _SectionCard(
      title: 'Support & Legal',
      icon: Icons.help_outline,
      children: [
        _buildLinkRow('Contact Support', Icons.support_agent_outlined),
        const Divider(height: 1),
        _buildLinkRow('Terms and Conditions', Icons.description_outlined),
        const Divider(height: 1),
        _buildLinkRow('Privacy Policy', Icons.privacy_tip_outlined),
        const Divider(height: 1),
        _buildLinkRow('My Seller Agreement', Icons.handshake_outlined),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchModeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            context.read<BusinessCubit>().switchMode(AppMode.buyer),
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text(S.of(context).switchToBuyerMode),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: AppColors.secondaryColor,
          side: const BorderSide(color: AppColors.secondaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context),
        icon: const Icon(Icons.logout),
        label: Text(S.of(context).deconnexion),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out of FGT AGRO?'),
        content: const Text('Your cart and seller data will be saved.'),
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

  // Helper Widgets
  Widget _buildInfoRow(
    String label,
    String value, {
    required bool isEditable,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (hint != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      hint,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isEditable)
            const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildDocRow(
    String name,
    String status,
    Color statusColor, {
    String action = 'Replace',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(fontSize: 12, color: statusColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(action, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {},
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.secondaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.secondaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
