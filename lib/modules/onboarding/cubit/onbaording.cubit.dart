import 'package:fgtagro_mobile/modules/onboarding/cubit/onboarding.state.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void setPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void completeOnboarding() {
    locator<StorageServices>().saveData('isFirstTime', false);
    emit(state.copyWith(isCompleted: true));
  }
}
