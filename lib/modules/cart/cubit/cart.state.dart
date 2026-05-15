import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';

class CartState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final bool showError;
  final Cart? cart;
  final double timerProgress; // 0.0 to 1.0
  final int remainingSeconds;

  CartState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.cart,
    this.timerProgress = 1.0,
    this.remainingSeconds = 0,
  });

  @override
  AppFailure? get error => genError;

  CartState copyWith({
    bool? genLoading,
    AppFailure? genError,
    bool? showError,
    Cart? cart,
    double? timerProgress,
    int? remainingSeconds,
  }) {
    return CartState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError, // Allow clearing
      showError: showError ?? this.showError,
      cart: cart ?? this.cart,
      timerProgress: timerProgress ?? this.timerProgress,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  @override
  List<Object?> get extraprops => [
    genLoading,
    genError,
    showError,
    cart,
    timerProgress,
    remainingSeconds,
  ];
}

class CartLoading extends CartState {}

class CartCheckoutLoading extends CartState {}

class CartCheckoutLoaded extends CartState {}

class CartDeliveryLoading extends CartState {}

class CartDeliveryLoaded extends CartState {}

class CardTransLoaded extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  CartLoaded({required this.cartItems});
}

class CartError extends CartState {
  @override
  final AppFailure error;

  CartError(this.error);
}
