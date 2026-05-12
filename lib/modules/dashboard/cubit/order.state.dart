import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';
import 'package:fgtagro_mobile/models/order.dart';

class OrderState extends GlobalAppState {
  final bool genLoading;
  final GlobalErrorData? genError;
  final bool showError;
  final List<OrderModel> orders;

  OrderState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.orders = const [],
  });

  OrderState copyWith({
    bool? genLoading,
    GlobalErrorData? genError,
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
