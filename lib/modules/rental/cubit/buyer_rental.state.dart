import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/models/equipment.dart';

class BuyerRentalState {
  final bool isLoading;
  final List<EquipmentModel> equipmentList;
  final List<BookingModel> myRentals;
  final String searchQuery;
  final String? selectedCategory;

  BuyerRentalState({
    this.isLoading = false,
    this.equipmentList = const [],
    this.myRentals = const [],
    this.searchQuery = '',
    this.selectedCategory,
  });

  BuyerRentalState copyWith({
    bool? isLoading,
    List<EquipmentModel>? equipmentList,
    List<BookingModel>? myRentals,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return BuyerRentalState(
      isLoading: isLoading ?? this.isLoading,
      equipmentList: equipmentList ?? this.equipmentList,
      myRentals: myRentals ?? this.myRentals,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
