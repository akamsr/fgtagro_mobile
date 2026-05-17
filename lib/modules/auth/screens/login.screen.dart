import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_button.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_layout.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_mode_toggle.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_text_field.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, AuthState state) {
    if (_formKey.currentState?.validate() ?? false) {
      if (state.loginMode == 'phone') {
        context.read<AuthCubit>().loginWithPhone(
          _phoneController.text,
          _passwordController.text,
        );
      } else {
        context.read<AuthCubit>().loginWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user != null) {
          CustomNavigate.replace(const HomeDashBoardRoute());
        }
        if (state.biometricError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.biometricError!)));
          context.read<AuthCubit>().clearBiometricError();
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: 'Welcome Back',
          subtitle: S.of(context).loginToAccount,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pas encore de compte ? ',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () {
                    CustomNavigate.push(const RegisterRoute());
                  },
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthModeToggle(
                  currentMode: state.loginMode,
                  onModeChanged: (mode) =>
                      context.read<AuthCubit>().setLoginMode(mode),
                ),
                const SizedBox(height: 32),

                // Fields
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.loginMode == 'phone'
                      ? AuthTextField(
                          key: const ValueKey('phone_field'),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          label: 'Numéro de téléphone',
                          prefixIcon: Icons.phone_outlined,
                          validator: (val) => val == null || val.isEmpty
                              ? S.of(context).requiredField
                              : null,
                        )
                      : AuthTextField(
                          key: const ValueKey('email_field'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          validator: (val) => val == null || val.isEmpty
                              ? S.of(context).requiredField
                              : null,
                        ),
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  controller: _passwordController,
                  obscureText: true,
                  label: 'Mot de passe',
                  prefixIcon: Icons.lock_outline,
                  validator: (val) => val == null || val.isEmpty
                      ? S.of(context).requiredField
                      : null,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      CustomNavigate.push(const ForgotPasswordRoute());
                    },
                    child: Text(
                      S.of(context).forgotPassword,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                AuthButton(
                  text: S.of(context).login.toUpperCase(),
                  isLoading: state.genLoading,
                  onPressed: () => _submit(context, state),
                ),

                if (state.isBiometricEnabled) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: IconButton(
                      onPressed: () =>
                          context.read<AuthCubit>().loginWithBiometrics(),
                      icon: Icon(
                        state.biometricType == 'face_id'
                            ? Icons.face
                            : Icons.fingerprint,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
