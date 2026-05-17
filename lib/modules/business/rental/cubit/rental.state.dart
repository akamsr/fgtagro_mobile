import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_app_state.dart';

class RentalState extends GlobalAppState {
  final bool genLoading;
  final AppFailure? genError;
  final List<EquipmentModel> equipment;
  final List<BookingModel> bookings;
  final List<BookingModel> history;

  RentalState({
    this.genLoading = false,
    this.genError,
    this.equipment = const [],
    this.bookings = const [],
    this.history = const [],
  });

  @override
  AppFailure? get error => genError;

  RentalState copyWith({
    bool? genLoading,
    AppFailure? genError,
    List<EquipmentModel>? equipment,
    List<BookingModel>? bookings,
    List<BookingModel>? history,
  }) {
    return RentalState(
      genLoading: genLoading ?? this.genLoading,
      genError: genError,
      equipment: equipment ?? this.equipment,
      bookings: bookings ?? this.bookings,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get extraprops => [
    genLoading,
    genError,
    equipment,
    bookings,
    history,
  ];
}
