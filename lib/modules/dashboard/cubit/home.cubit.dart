import 'dart:async';

import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home.state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {}

  List<String> cities = [];
  bool checkNow = false;

  Future<void> stopCheck() async {
    checkNow = false;
    refresh();
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void emitLoading() {
    emit(state.copyWith(genLoading: true));
  }

  void emitLoaded() {
    emit(state.copyWith(genLoading: false));
  }

  final FocusNode focusNode = FocusNode();
  bool isSearchFieldFocused = false;

  int? _selectedCategory;
  int? get selectedCategory => _selectedCategory;
  int? _selectedType;
  int? get selectedType => _selectedType;
  bool displaySearch = false;

  final PageController pageController = PageController();
  final PageController nearbyServicePageController = PageController();
  late ScrollController scrollController;

  void refresh() {
    emit(state.copyWith(genLoading: true));
    emit(state.copyWith(genLoading: false));
  }

  void animateToIndex(int index, String direction) {
    pageController.animateToPage(
      direction == 'front' ? index + 1 : index - 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInCirc,
    );
  }

  void emitError(dynamic e, StackTrace s) {
    emit(
      state.copyWith(
        genLoading: false,
        genError: ErrorMapper.map(e, s),
      ),
    );
  }

  Future<bool> getPermission() async {
    final permission = await Geolocator.requestPermission();
    final bool granted =
        ((permission == LocationPermission.always) ||
        (permission == LocationPermission.whileInUse));
    return granted;
  }

  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return (permission == LocationPermission.always ||
        (permission == LocationPermission.whileInUse));
  }

  Future<void> grantPermission() async {
    final Location location = new Location();
    final bool granted = await getPermission();
    if (!granted) {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }
      await openAppSettings();
    } else {
      await initialize();
    }
  }

  Future<void> initialize() async {
    displaySearch = false;
    refresh();
    emit(state.copyWith(genLoading: true, noInternet: false));

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied.',
      );
    }
  }
}
