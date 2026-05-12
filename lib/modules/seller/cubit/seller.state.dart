import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';

class SellerState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final bool showError;
  final SellerProfileModel? profile;
  final List<StoreModel> stores;

  SellerState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.profile,
    this.stores = const [],
  });

  @override
  AppFailure? get error => genError;

  SellerState copyWith({
    bool? genLoading,
    AppFailure? genError,
    bool? showError,
    SellerProfileModel? profile,
    List<StoreModel>? stores,
  }) {
    return SellerState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      showError: showError ?? this.showError,
      profile: profile ?? this.profile,
      stores: stores ?? this.stores,
    );
  }

  @override
  List<Object?> get extraprops => [
    genLoading,
    genError,
    showError,
    profile,
    stores,
  ];
}
