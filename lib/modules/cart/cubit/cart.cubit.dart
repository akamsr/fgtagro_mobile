import 'dart:async';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/services/cart/local_cart.service.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart.state.dart';

class CartCubit extends Cubit<CartState> {
  final LocalCartService _service = LocalCartService();
  Timer? _timer;
  static const int reservationDuration = 15 * 60;

  CartCubit() : super(CartState());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  // ── Load ──────────────────────────────────────────────────────────────────

  void fetchCart() {
    try {
      final cart = _service.getCart();
      emit(state.copyWith(cart: cart, genLoading: false, genError: null, showError: false));
      _manageTimer(cart.expiresAt);
    } catch (e, s) {
      emit(state.copyWith(
        genLoading: false,
        genError: ErrorMapper.map(e, s),
        showError: true,
      ));
    }
  }

  // ── Add ───────────────────────────────────────────────────────────────────

  void addToCart(ProductModel product, {int qty = 1}) {
    try {
      final cart = _service.addItem(product, qty: qty);
      emit(state.copyWith(cart: cart, genLoading: false));
      _manageTimer(cart.expiresAt);
    } catch (e, s) {
      emit(state.copyWith(genError: ErrorMapper.map(e, s), showError: true));
    }
  }

  // ── Remove ────────────────────────────────────────────────────────────────

  void removeFromCart(int cartItemId) {
    try {
      final cart = _service.removeItem(cartItemId);
      if (cart.items.isEmpty) {
        _timer?.cancel();
        emit(state.copyWith(cart: cart, remainingSeconds: 0, timerProgress: 1.0));
      } else {
        emit(state.copyWith(cart: cart));
        _manageTimer(cart.expiresAt);
      }
    } catch (e, s) {
      emit(state.copyWith(genError: ErrorMapper.map(e, s), showError: true));
    }
  }

  // ── Update quantity ───────────────────────────────────────────────────────

  void updateQuantity(int cartItemId, int qty) {
    if (qty <= 0) {
      removeFromCart(cartItemId);
      return;
    }
    try {
      final cart = _service.updateQty(cartItemId, qty);
      emit(state.copyWith(cart: cart));
      _manageTimer(cart.expiresAt);
    } catch (e, s) {
      emit(state.copyWith(genError: ErrorMapper.map(e, s), showError: true));
    }
  }

  // ── Clear ─────────────────────────────────────────────────────────────────

  void clearCart() {
    _timer?.cancel();
    final cart = _service.clearCart();
    emit(state.copyWith(cart: cart, remainingSeconds: 0, timerProgress: 1.0));
  }

  // ── Timer ─────────────────────────────────────────────────────────────────

  void _manageTimer(String? expiresAt) {
    _timer?.cancel();
    if (expiresAt == null) return;

    final expiry = DateTime.tryParse(expiresAt);
    if (expiry == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = expiry.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(remainingSeconds: 0, timerProgress: 0.0));
      } else {
        emit(state.copyWith(
          remainingSeconds: remaining,
          timerProgress: remaining / reservationDuration,
        ));
      }
    });
  }

  void hideError() => emit(state.copyWith(showError: false));
}
