import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';

class SellerGate extends StatelessWidget {
  final Widget child;

  const SellerGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        final status = state.sellerStatus;

        if (status == 'VALIDATED') {
          return child;
        }

        if (status == 'PENDING') {
          return _buildStatusScreen(
            context,
            icon: Icons.schedule_rounded,
            title: S.of(context).verificationInProgress,
            message: S.of(context).verificationMessage,
            color: Colors.orange,
          );
        }

        if (status == 'REJECTED' || status == 'SUSPENDED') {
          return _buildStatusScreen(
            context,
            icon: Icons.error_outline_rounded,
            title: status == 'REJECTED'
                ? S.of(context).applicationRejected
                : S.of(context).accountSuspended,
            message:
                state.profile?.rejectionReason ??
                S.of(context).contactSupportMessage,
            color: Colors.red,
            showSupport: true,
          );
        }

        // Default to onboarding/pending if no profile
        return _buildStatusScreen(
          context,
          icon: Icons.business_center_outlined,
          title: S.of(context).businessRegistration,
          message: S.of(context).completeRegistrationMessage,
          color: AppColors.primaryColor,
          buttonLabel: S.of(context).completeRegistration,
          onAction: () => context.router.push(const SellerOnboardRoute()),
        );
      },
    );
  }

  Widget _buildStatusScreen(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required Color color,
    bool showSupport = false,
    String? buttonLabel,
    VoidCallback? onAction,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 64),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            if (buttonLabel != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (showSupport)
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.headset_mic_outlined),
                label: Text(S.of(context).contactSupport),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<BusinessCubit>().switchMode(AppMode.buyer),
              child: Text(S.of(context).switchToBuyerMode),
            ),
          ],
        ),
      ),
    );
  }
}
