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
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).acceptTerms)),
        );
        return;
      }

      context.read<AuthCubit>().register(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phoneCode: '+237',
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
            acceptTerms: _acceptTerms,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user != null) {
          CustomNavigate.replace(VerifyEmailRoute(email: _emailController.text));
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: S.of(context).createAccount,
          subtitle: S.of(context).joinUsToday,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).alreadyHaveAccount,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () {
                    CustomNavigate.push(const LoginRoute());
                  },
                  child: const Text(
                    ' Se connecter',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AuthTextField(
                        controller: _firstNameController,
                        label: S.of(context).firstName,
                        hintText: 'John',
                        validator: (val) => val == null || val.isEmpty
                            ? S.of(context).requiredField
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AuthTextField(
                        controller: _lastNameController,
                        label: S.of(context).lastName,
                        hintText: 'Doe',
                        validator: (val) => val == null || val.isEmpty
                            ? S.of(context).requiredField
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: S.of(context).email,
                  hintText: 'example@mail.com',
                  prefixIcon: Icons.mail_outline,
                  validator: (val) =>
                      val == null || val.isEmpty ? S.of(context).requiredField : null,
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  label: S.of(context).phone,
                  hintText: '600 000 000',
                  prefixIcon: Icons.phone_outlined,
                  validator: (val) =>
                      val == null || val.isEmpty ? S.of(context).requiredField : null,
                ),
                const SizedBox(height: 20),

                AuthTextField(
                  controller: _passwordController,
                  obscureText: true,
                  label: S.of(context).password,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) =>
                      val == null || val.isEmpty ? S.of(context).requiredField : null,
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
                const SizedBox(height: 16),

                Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primaryColor;
                        }
                        return Colors.transparent;
                      }),
                      side: const BorderSide(color: AppColors.borderStrong),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      S.of(context).iAcceptTerms,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _acceptTerms,
                    onChanged: (val) {
                      setState(() {
                        _acceptTerms = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                AuthButton(
                  text: S.of(context).register.toUpperCase(),
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

