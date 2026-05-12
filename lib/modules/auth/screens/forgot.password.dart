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
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().forgotPassword(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.success) {
          CustomNavigate.push(ResetPasswordOtpRoute(email: _emailController.text));
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: S.of(context).forgotPassword,
          subtitle: S.of(context).enterEmailToReset,
          actions: [
            Center(
              child: TextButton(
                onPressed: () => CustomNavigate.pop(context),
                child: const Text(
                  'Retour à la connexion',
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: S.of(context).email,
                  hintText: 'example@mail.com',
                  prefixIcon: Icons.mail_outline,
                  validator: (val) =>
                      val == null || val.isEmpty ? S.of(context).requiredField : null,
                ),
                const SizedBox(height: 32),

                AuthButton(
                  text: S.of(context).sendResetLink.toUpperCase(),
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

