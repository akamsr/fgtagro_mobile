import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_button.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_layout.dart';
import 'package:fgtagro_mobile/modules/auth/widgets/auth_text_field.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

@RoutePage()
class VerifyEmailScreen extends StatefulWidget {
  final String? email;
  const VerifyEmailScreen({Key? key, this.email}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();

  static const int _resendDelay = 60;
  int _countdown = _resendDelay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _countdown = _resendDelay);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tokenController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().verifyEmail(
            widget.email ?? '',
            _tokenController.text,
          );
    }
  }

  void _resend(BuildContext context) {
    if (_countdown == 0 && widget.email != null) {
      context.read<AuthCubit>().resendVerificationEmail(widget.email!);
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.success) {
          CustomNavigate.replace(const HomeDashBoardRoute());
        }
      },
      builder: (context, state) {
        return AuthLayout(
          title: 'Verify Email',
          subtitle: 'Enter the 6-digit code sent to\n${widget.email ?? ''}',
          actions: [
            Center(
              child: TextButton(
                onPressed: _countdown == 0 && widget.email != null
                    ? () => _resend(context)
                    : null,
                child: Text(
                  _countdown > 0
                      ? 'Resend in $_countdown s'
                      : 'Resend Code',
                  style: TextStyle(
                    color: _countdown > 0
                        ? AppColors.textSecondary
                        : AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                  controller: _tokenController,
                  keyboardType: TextInputType.number,
                  label: 'Verification Code',
                  hintText: '000000',
                  prefixIcon: Icons.key_outlined,
                  validator: (val) => val == null || val.length != 6
                      ? 'Required 6 digits'
                      : null,
                ),
                const SizedBox(height: 32),

                AuthButton(
                  text: 'VERIFY',
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

