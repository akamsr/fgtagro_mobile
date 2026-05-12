import 'package:fgtagro_mobile/services/order/order.services.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
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
    } catch (e, s) {
      emit(
        state.copyWith(
          genLoading: false,
          genError: ErrorMapper.map(e, s),
          showError: true,
        ),
      );
    }
  }

  void hideError() {
    emit(state.copyWith(showError: false));
  }
}
