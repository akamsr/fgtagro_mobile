import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_mode_toggle.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.showError && state.genError != null) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Erreur: ${state.genError?.message ?? "Une erreur est survenue"}')),
              // );
              // context.read<AuthCubit>().hideError();
            }
            if (state.user != null) {
              context.router.replace(const HomeDashBoardRoute());
            }
            if (state.biometricError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.biometricError!)));
              context.read<AuthCubit>().clearBiometricError();
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 40.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        const Icon(
                          Icons.lock_outline,
                          size: 64,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'FGT AGRO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Connectez-vous à votre compte',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),

                        // Toggle
                        AuthModeToggle(
                          currentMode: state.loginMode,
                          onModeChanged: (mode) =>
                              context.read<AuthCubit>().setLoginMode(mode),
                        ),
                        const SizedBox(height: 24),

                        // Fields
                        if (state.loginMode == 'phone')
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Numéro de téléphone',
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Requis' : null,
                          )
                        else
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Requis' : null,
                          ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Requis' : null,
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.router.push(const ForgotPasswordRoute());
                            },
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: state.genLoading
                              ? null
                              : () => _submit(context, state),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.genLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Se connecter'),
                        ),

                        if (state.isBiometricEnabled) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () =>
                                context.read<AuthCubit>().loginWithBiometrics(),
                            icon: Icon(
                              state.biometricType == 'face_id'
                                  ? Icons.face
                                  : Icons.fingerprint,
                              color: AppColors.primaryColor,
                            ),
                            label: const Text('Connexion Biométrique'),
                          ),
                        ],
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pas encore de compte ? '),
                            TextButton(
                              onPressed: () {
                                context.router.push(const RegisterRoute());
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
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
