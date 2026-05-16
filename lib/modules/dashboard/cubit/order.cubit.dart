import 'package:fgtagro_mobile/models/order.dart';
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
      // Mock some data if needed for the specific seller requirements
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

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void hideError() {
    emit(state.copyWith(showError: false));
  }

  List<OrderModel> getFilteredOrders(OrderStatus? filterStatus) {
    var filtered = state.orders;
    
    if (filterStatus != null) {
      filtered = filtered.where((o) => o.status == filterStatus).toList();
    }
    
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered = filtered.where((o) {
        return o.orderNumber.toLowerCase().contains(q) ||
               (o.buyerCity?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    
    // Sort by most recent first
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filtered;
  }
}
