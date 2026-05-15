import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';

enum AppMode { buyer, seller }

class BusinessState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final bool showError;
  final SellerProfileModel? profile;
  final List<StoreModel> stores;
  final AppMode appMode;

  BusinessState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.profile,
    this.stores = const [],
    this.appMode = AppMode.buyer,
  });

  bool get isSellerMode => appMode == AppMode.seller;
  
  // Helper to check seller validation status
  String get sellerStatus => profile?.status.toUpperCase() ?? 'NONE';
  bool get isValidated => sellerStatus == 'VALIDATED';

  @override
  AppFailure? get error => genError;

  BusinessState copyWith({
    bool? genLoading,
    AppFailure? genError,
    bool? showError,
    SellerProfileModel? profile,
    List<StoreModel>? stores,
    AppMode? appMode,
  }) {
    return BusinessState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      showError: showError ?? this.showError,
      profile: profile ?? this.profile,
      stores: stores ?? this.stores,
      appMode: appMode ?? this.appMode,
    );
  }

  @override
  List<Object?> get extraprops => [
    genLoading,
    genError,
    showError,
    profile,
    stores,
    appMode,
  ];
}
