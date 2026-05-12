import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';
import 'package:fgtagro_mobile/models/order.dart';

class OrderState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final bool showError;
  final List<OrderModel> orders;

  OrderState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.orders = const [],
  });

  @override
  AppFailure? get error => genError;

  OrderState copyWith({
    bool? genLoading,
    AppFailure? genError,
    bool? showError,
    List<OrderModel>? orders,
  }) {
    return OrderState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      showError: showError ?? this.showError,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get extraprops => [genLoading, genError, showError, orders];
}
