import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/services/cart/cart.services.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart.state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService = CartService();

  CartCubit() : super(CartState());

  Future<void> fetchCart() async {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
    try {
      final cart = await _cartService.getCart();
      emit(state.copyWith(genLoading: false, cart: cart));
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

  Future<void> addToCart(String productId, {int qty = 1}) async {
    emit(state.copyWith(genLoading: true));
    try {
      final cart = await _cartService.addToCart(productId, qty);
      emit(state.copyWith(genLoading: false, cart: cart));
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

  Future<void> removeFromCart(int cartItemId) async {
    emit(state.copyWith(genLoading: true));
    try {
      final cart = await _cartService.removeFromCart(cartItemId);
      emit(state.copyWith(genLoading: false, cart: cart));
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

  Future<void> updateQuantity(int cartItemId, int qty) async {
    if (qty <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    emit(state.copyWith(genLoading: true));
    try {
      final cart = await _cartService.updateQuantity(cartItemId, qty);
      emit(state.copyWith(genLoading: false, cart: cart));
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
