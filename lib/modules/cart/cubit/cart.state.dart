import 'package:fgtagro_mobile/models/cart.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/global_app_state.dart';

class CartState extends GlobalAppState {
  final bool genLoading;
  final GlobalErrorData? genError;
  final bool showError;
  final Cart? cart;

  CartState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.cart,
  });

  CartState copyWith({
    bool? genLoading,
    GlobalErrorData? genError,
    bool? showError,
    Cart? cart,
  }) {
    return CartState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError ?? this.genError,
      showError: showError ?? this.showError,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object?> get extraprops => [genLoading, genError, showError, cart];
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
  final GlobalErrorData error;

  CartError(this.error);
}
