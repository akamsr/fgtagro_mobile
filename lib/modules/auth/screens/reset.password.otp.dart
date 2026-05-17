import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_button.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_layout.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_text_field.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ResetPasswordOtpScreen extends StatefulWidget {
  final String? email;
  const ResetPasswordOtpScreen({Key? key, this.email}) : super(key: key);

  @override
  State<ResetPasswordOtpScreen> createState() => _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().resetPassword(
        email: widget.email ?? '',
        otp: _otpController.text,
        newPassword: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).passwordResetSuccessful)),
          );
          CustomNavigate.replaceAll([const LoginRoute()]);
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: S.of(context).resetPassword,
          subtitle: S.of(context).enterOtpSentTo(widget.email ?? ''),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => CustomNavigate.pop(context),
                child: const Text(
                  'Retour',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  label: S.of(context).otpCode,
                  hintText: '000000',
                  prefixIcon: Icons.pin_outlined,
                  validator: (val) => val == null || val.length != 6
                      ? S.of(context).required6Digits
                      : null,
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  controller: _passwordController,
                  obscureText: true,
                  label: S.of(context).newPassword,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) => val == null || val.isEmpty
                      ? S.of(context).requiredField
                      : null,
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  label: S.of(context).confirmPassword,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return S.of(context).requiredField;
                    if (val != _passwordController.text)
                      return S.of(context).passwordsDoNotMatch;
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                AuthButton(
                  text: S.of(context).resetPassword.toUpperCase(),
                  isLoading: state.genLoading,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
