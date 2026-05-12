import 'package:fgtagro_mobile/services/seller/seller.services.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'seller.state.dart';

class SellerCubit extends Cubit<SellerState> {
  final SellerService sellerService;

  SellerCubit({SellerService? sellerService})
      : sellerService = sellerService ?? SellerService(),
        super(SellerState());

  void emitLoading() {
    emit(state.copyWith(genLoading: true, genError: null, showError: false));
  }

  void emitLoaded() {
    emit(state.copyWith(genLoading: false));
  }

  void emitError(dynamic e, StackTrace s) {
    emit(
      state.copyWith(
        genLoading: false,
        genError: ErrorMapper.map(e, s),
        showError: true,
      ),
    );
  }

  Future<void> onboardSeller(Map<String, dynamic> data) async {
    emitLoading();
    try {
      final profile = await sellerService.onboardSeller(data);
      emit(state.copyWith(genLoading: false, profile: profile));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> fetchProfile() async {
    emitLoading();
    try {
      final profile = await sellerService.getSellerProfile();
      emit(state.copyWith(genLoading: false, profile: profile));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> fetchStores() async {
    emitLoading();
    try {
      final stores = await sellerService.getMyStores();
      emit(state.copyWith(genLoading: false, stores: stores));
    } catch (e, s) {
      emitError(e, s);
    }
  }

  Future<void> createStore(Map<String, dynamic> data) async {
    emitLoading();
    try {
      final newStore = await sellerService.createStore(data);
      final updatedStores = [...state.stores, newStore];
      emit(state.copyWith(genLoading: false, stores: updatedStores));
    } catch (e, s) {
      emitError(e, s);
    }
  }
}
