import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';
import 'package:fgtagro_mobile/utils/error/reporting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/no_connection.dart';

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
        if (renderError && state.error != null) {
          if (errorWidget != null) return errorWidget!;
          if (state.error!.type == FailureType.network) {
            return NoConnection(onTap: onRefresh);
          }
        }
        return builder(ctx, state);
      },
      listenWhen: listenWhen,
      buildWhen: buildWhen,
      listener: (ctx, state) {
        if (state.error != null) ReportingService.report(state.error!);
        if (listener != null) listener!(ctx, state);
      },
    );
  }
}
