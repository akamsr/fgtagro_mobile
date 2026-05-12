part of 'home.cubit.dart';

class HomeState extends GlobalAppState {
  final bool genLoading;
  final bool showError;
  final AppFailure? genError;
  final bool noInternet;
  final bool filterLoading;
  final bool locationPermisionsAccepted;
  final bool browseEmpty;

  HomeState({
    this.genLoading = false,
    this.genError,
    this.showError = false,
    this.browseEmpty = false,
    this.noInternet = false,
    this.filterLoading = false,
    this.locationPermisionsAccepted = true,
  });

  @override
  AppFailure? get error => genError;

  HomeState copyWith({
    bool? genLoading,
    bool? showError,
    bool? filterLoading,
    AppFailure? genError,
    bool? noInternet,
    bool? locationPermisionsAccepted,
    bool? browseEmpty,
  }) {
    return HomeState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError ?? this.genError,
      showError: showError ?? this.showError,
      noInternet: noInternet ?? this.noInternet,
      filterLoading: filterLoading ?? this.filterLoading,
      browseEmpty: browseEmpty ?? this.browseEmpty,
      locationPermisionsAccepted:
          locationPermisionsAccepted ?? this.locationPermisionsAccepted,
    );
  }

  @override
  List<Object?> get extraprops => [
    genLoading,
    genError,
    showError,
    locationPermisionsAccepted,
    filterLoading,
  ];
}
