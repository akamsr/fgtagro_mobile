import 'package:fgtagro_mobile/services/order/order.services.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order.state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService _orderService = OrderService();

  OrderCubit() : super(OrderState());

  Future<void> fetchOrders() async {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
    try {
      final orders = await _orderService.getOrders();
      emit(state.copyWith(genLoading: false, orders: orders));
    } catch (e) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: GlobalErrorData(e),
          showError: true,
        ),
      );
    }
  }

  void hideError() {
    emit(state.copyWith(showError: false));
  }
}
