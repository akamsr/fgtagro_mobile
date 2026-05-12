// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:fgtagro_mobile/modules/auth/screens/forgot.password.dart'
    as _i8;
import 'package:fgtagro_mobile/modules/auth/screens/login.screen.dart' as _i10;
import 'package:fgtagro_mobile/modules/auth/screens/register.screen.dart'
    as _i15;
import 'package:fgtagro_mobile/modules/auth/screens/reset.password.otp.dart'
    as _i16;
import 'package:fgtagro_mobile/modules/auth/screens/verify.email.dart' as _i19;
import 'package:fgtagro_mobile/modules/cart/screens/cart_screen.dart' as _i1;
import 'package:fgtagro_mobile/modules/cart/screens/checkout.screen.dart'
    as _i3;
import 'package:fgtagro_mobile/modules/conversation/screens/conversation.detail.dart'
    as _i4;
import 'package:fgtagro_mobile/modules/conversation/screens/conversation.list.dart'
    as _i5;
import 'package:fgtagro_mobile/modules/dashboard/dashboard.shell.dart' as _i9;
import 'package:fgtagro_mobile/modules/dashboard/screens/dashboard.categories.dart'
    as _i2;
import 'package:fgtagro_mobile/modules/dashboard/screens/dashboard.home.dart'
    as _i7;
import 'package:fgtagro_mobile/modules/dashboard/screens/dashboard.orders.dart'
    as _i11;
import 'package:fgtagro_mobile/modules/product/screens/product.detail.dart'
    as _i12;
import 'package:fgtagro_mobile/modules/product/screens/product.list.dart'
    as _i13;
import 'package:fgtagro_mobile/modules/profile/screens/user.profile.dart'
    as _i14;
import 'package:fgtagro_mobile/modules/seller/screens/seller.dashboard.dart'
    as _i17;
import 'package:fgtagro_mobile/modules/seller/screens/seller.onboard.dart'
    as _i18;
import 'package:fgtagro_mobile/modules/seller/screens/store.create.dart' as _i6;
import 'package:flutter/material.dart' as _i21;

/// generated route for
/// [_i1.CartScreen]
class CartRoute extends _i20.PageRouteInfo<void> {
  const CartRoute({List<_i20.PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartScreen();
    },
  );
}

/// generated route for
/// [_i2.CategoriesScreen]
class CategoriesRoute extends _i20.PageRouteInfo<void> {
  const CategoriesRoute({List<_i20.PageRouteInfo>? children})
    : super(CategoriesRoute.name, initialChildren: children);

  static const String name = 'CategoriesRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i2.CategoriesScreen();
    },
  );
}

/// generated route for
/// [_i3.CheckoutScreen]
class CheckoutRoute extends _i20.PageRouteInfo<void> {
  const CheckoutRoute({List<_i20.PageRouteInfo>? children})
    : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i3.CheckoutScreen();
    },
  );
}

/// generated route for
/// [_i4.ConversationDetailScreen]
class ConversationDetailRoute
    extends _i20.PageRouteInfo<ConversationDetailRouteArgs> {
  ConversationDetailRoute({
    _i21.Key? key,
    required String id,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         ConversationDetailRoute.name,
         args: ConversationDetailRouteArgs(key: key, id: id),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'ConversationDetailRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ConversationDetailRouteArgs>(
        orElse: () =>
            ConversationDetailRouteArgs(id: pathParams.getString('id')),
      );
      return _i4.ConversationDetailScreen(key: args.key, id: args.id);
    },
  );
}

class ConversationDetailRouteArgs {
  const ConversationDetailRouteArgs({this.key, required this.id});

  final _i21.Key? key;

  final String id;

  @override
  String toString() {
    return 'ConversationDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConversationDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i5.ConversationListScreen]
class ConversationListRoute extends _i20.PageRouteInfo<void> {
  const ConversationListRoute({List<_i20.PageRouteInfo>? children})
    : super(ConversationListRoute.name, initialChildren: children);

  static const String name = 'ConversationListRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i5.ConversationListScreen();
    },
  );
}

/// generated route for
/// [_i6.CreateStoreScreen]
class CreateStoreRoute extends _i20.PageRouteInfo<void> {
  const CreateStoreRoute({List<_i20.PageRouteInfo>? children})
    : super(CreateStoreRoute.name, initialChildren: children);

  static const String name = 'CreateStoreRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i6.CreateStoreScreen();
    },
  );
}

/// generated route for
/// [_i7.DashboardHomeScreen]
class DashboardHomeRoute extends _i20.PageRouteInfo<void> {
  const DashboardHomeRoute({List<_i20.PageRouteInfo>? children})
    : super(DashboardHomeRoute.name, initialChildren: children);

  static const String name = 'DashboardHomeRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardHomeScreen();
    },
  );
}

/// generated route for
/// [_i8.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i20.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i20.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i8.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i9.HomeDashBoardPage]
class HomeDashBoardRoute extends _i20.PageRouteInfo<void> {
  const HomeDashBoardRoute({List<_i20.PageRouteInfo>? children})
    : super(HomeDashBoardRoute.name, initialChildren: children);

  static const String name = 'HomeDashBoardRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomeDashBoardPage();
    },
  );
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i20.PageRouteInfo<void> {
  const LoginRoute({List<_i20.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i10.LoginScreen();
    },
  );
}

/// generated route for
/// [_i11.OrdersScreen]
class OrdersRoute extends _i20.PageRouteInfo<void> {
  const OrdersRoute({List<_i20.PageRouteInfo>? children})
    : super(OrdersRoute.name, initialChildren: children);

  static const String name = 'OrdersRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i11.OrdersScreen();
    },
  );
}

/// generated route for
/// [_i12.ProductDetailScreen]
class ProductDetailRoute extends _i20.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i21.Key? key,
    required String id,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, id: id),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProductDetailRouteArgs>(
        orElse: () => ProductDetailRouteArgs(id: pathParams.getString('id')),
      );
      return _i12.ProductDetailScreen(key: args.key, id: args.id);
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.id});

  final _i21.Key? key;

  final String id;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i13.ProductListScreen]
class ProductListRoute extends _i20.PageRouteInfo<void> {
  const ProductListRoute({List<_i20.PageRouteInfo>? children})
    : super(ProductListRoute.name, initialChildren: children);

  static const String name = 'ProductListRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProductListScreen();
    },
  );
}

/// generated route for
/// [_i14.ProfileScreen]
class ProfileRoute extends _i20.PageRouteInfo<void> {
  const ProfileRoute({List<_i20.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i14.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i15.RegisterScreen]
class RegisterRoute extends _i20.PageRouteInfo<void> {
  const RegisterRoute({List<_i20.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i15.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i16.ResetPasswordOtpScreen]
class ResetPasswordOtpRoute
    extends _i20.PageRouteInfo<ResetPasswordOtpRouteArgs> {
  ResetPasswordOtpRoute({
    _i21.Key? key,
    String? email,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         ResetPasswordOtpRoute.name,
         args: ResetPasswordOtpRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'ResetPasswordOtpRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordOtpRouteArgs>(
        orElse: () => const ResetPasswordOtpRouteArgs(),
      );
      return _i16.ResetPasswordOtpScreen(key: args.key, email: args.email);
    },
  );
}

class ResetPasswordOtpRouteArgs {
  const ResetPasswordOtpRouteArgs({this.key, this.email});

  final _i21.Key? key;

  final String? email;

  @override
  String toString() {
    return 'ResetPasswordOtpRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetPasswordOtpRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [_i17.SellerDashboardScreen]
class SellerDashboardRoute extends _i20.PageRouteInfo<void> {
  const SellerDashboardRoute({List<_i20.PageRouteInfo>? children})
    : super(SellerDashboardRoute.name, initialChildren: children);

  static const String name = 'SellerDashboardRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i17.SellerDashboardScreen();
    },
  );
}

/// generated route for
/// [_i18.SellerOnboardScreen]
class SellerOnboardRoute extends _i20.PageRouteInfo<void> {
  const SellerOnboardRoute({List<_i20.PageRouteInfo>? children})
    : super(SellerOnboardRoute.name, initialChildren: children);

  static const String name = 'SellerOnboardRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i18.SellerOnboardScreen();
    },
  );
}

/// generated route for
/// [_i19.VerifyEmailScreen]
class VerifyEmailRoute extends _i20.PageRouteInfo<VerifyEmailRouteArgs> {
  VerifyEmailRoute({
    _i21.Key? key,
    String? email,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         VerifyEmailRoute.name,
         args: VerifyEmailRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'VerifyEmailRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyEmailRouteArgs>(
        orElse: () => const VerifyEmailRouteArgs(),
      );
      return _i19.VerifyEmailScreen(key: args.key, email: args.email);
    },
  );
}

class VerifyEmailRouteArgs {
  const VerifyEmailRouteArgs({this.key, this.email});

  final _i21.Key? key;

  final String? email;

  @override
  String toString() {
    return 'VerifyEmailRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerifyEmailRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}
