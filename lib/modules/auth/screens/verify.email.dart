import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
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
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.showError && state.genError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.genError?.message}')),
                );
              }

              if (state.success) {
                CustomNavigate.replace(const HomeDashBoardRoute());
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => CustomNavigate.pop(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Icon(
                            Icons.mark_email_read_outlined,
                            size: 64,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Verify Email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter the 6-digit code sent to\n${widget.email ?? ''}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _tokenController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              labelText: 'Verification Code',
                              prefixIcon: const Icon(Icons.key_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (val) => val == null || val.length != 6
                                ? 'Required 6 digits'
                                : null,
                          ),
                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: state.genLoading
                                ? null
                                : () => _submit(context),
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
                                : const Text('Verify'),
                          ),
                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: _countdown == 0 && widget.email != null
                                ? () => _resend(context)
                                : null,
                            child: Text(
                              _countdown > 0
                                  ? 'Resend in $_countdown s'
                                  : 'Resend Code',
                              style: TextStyle(
                                color: _countdown > 0
                                    ? Colors.grey
                                    : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }
}
