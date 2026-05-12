import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/no_connection.dart';
import '../error_service.dart';
import 'global_app_state.dart';
import 'dart:async';
import 'models/error_mapping.dart';

class CustomBlocConsumer<B extends BlocBase<S>, S extends GlobalAppState>
    extends StatelessWidget {
  const CustomBlocConsumer({
    Key? key,
    required this.builder,
    this.listener,
    this.buildWhen,
    this.listenWhen,
    this.errorWidget,
    this.renderError = false,
    this.onRefresh,
  }) : super(key: key);

  final Widget Function(BuildContext context, S state) builder;
  final void Function(BuildContext context, S state)? listener;
  final bool Function(S, S)? buildWhen;
  final bool Function(S, S)? listenWhen;
  final Widget? errorWidget;
  final bool renderError;
  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      builder: (ctx, state) {
        if (state.error != null) {
          final GlobalErrorData error = state.error!;
          if (!error.showToUser) {
            if (renderError) {
              if (errorWidget != null) {
                return errorWidget!;
              }
              if (state.error!.errorType == ErrorType.NoConnection) {
                return NoConnection(onTap: onRefresh);
              }
            }
          }
        }
        return builder(ctx, state);
      },
      listenWhen: listenWhen,
      buildWhen: buildWhen,
      listener: (ctx, state) {
        if (state.error != null) {
          final GlobalErrorData error = state.error!;
          reportError(error);
          // if (state.error!.errorType == ErrorType.NoConnection) {
          //   if (!error.showToUser)
          //     showSlowInternetModalSheet(ctx, onRefresh!);
          // }
        }

        if (listener != null) {
          listener!(ctx, state);
        }
      },
    );
  }

  Future<void> reportError(GlobalErrorData data) async {
    if (ErrorService.shouldBeReported(data)) {
      unawaited(ErrorService.handleError(data.error, data.stackTrace));
    }
  }
}
