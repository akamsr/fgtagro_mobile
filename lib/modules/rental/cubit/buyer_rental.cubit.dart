import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'buyer_rental.state.dart';

class BuyerRentalCubit extends Cubit<BuyerRentalState> {
  BuyerRentalCubit() : super(BuyerRentalState());

  void fetchInitialData() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    final mockEquipment = [
      EquipmentModel(
        id: 'eq1',
        type: 'Tractor',
        brand: 'John Deere',
        model: '5075E',
        yearOfManufacture: 2022,
        enginePower: 75,
        enginePowerUnit: 'HP',
        condition: 'Excellent',
        dailyRate: 75000,
        securityDeposit: 150000,
        fuelPolicy: 'Full-to-full',
        status: 'PUBLISHED',
        isAvailable: true,
        photoSlots: {'front': 'https://example.com/tractor_front.jpg'},
      ),
      EquipmentModel(
        id: 'eq2',
        type: 'Harvester',
        brand: 'Claas',
        model: 'Lexion 8000',
        yearOfManufacture: 2021,
        enginePower: 400,
        enginePowerUnit: 'HP',
        condition: 'Good',
        dailyRate: 250000,
        securityDeposit: 500000,
        fuelPolicy: 'Full-to-full',
        status: 'PUBLISHED',
        isAvailable: true,
        photoSlots: {'front': 'https://example.com/harvester_front.jpg'},
      ),
      EquipmentModel(
        id: 'eq3',
        type: 'Irrigation Pump',
        brand: 'Honda',
        model: 'WB30',
        yearOfManufacture: 2023,
        enginePower: 5,
        enginePowerUnit: 'HP',
        condition: 'Excellent',
        dailyRate: 15000,
        securityDeposit: 50000,
        fuelPolicy: 'Tenant pays separately',
        status: 'PUBLISHED',
        isAvailable: true,
        photoSlots: {'front': 'https://example.com/pump_front.jpg'},
      ),
    ];

    final mockUser = UserModel(
      uid: 'u1',
      id: 1,
      fullNames: 'Jean Dupont',
      email: 'jean@example.com',
      phoneNumber: '+237600000000',
    );

    final mockBookings = [
      BookingModel(
        id: 'bkg1',
        equipment: mockEquipment[0],
        tenant: mockUser,
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        totalAmount: 225000,
        status: 'PENDING',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      BookingModel(
        id: 'bkg2',
        equipment: mockEquipment[1],
        tenant: mockUser,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 1)),
        totalAmount: 500000,
        status: 'ACTIVE',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    emit(state.copyWith(
      isLoading: false,
      equipmentList: mockEquipment,
      myRentals: mockBookings,
    ));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setCategory(String? category) {
    emit(state.copyWith(selectedCategory: category));
  }

  List<EquipmentModel> getFilteredEquipment() {
    return state.equipmentList.where((eq) {
      if (state.selectedCategory != null && state.selectedCategory != 'All' && eq.type != state.selectedCategory) {
        return false;
      }
      if (state.searchQuery.isNotEmpty) {
        final query = state.searchQuery.toLowerCase();
        return eq.brand.toLowerCase().contains(query) ||
            eq.model.toLowerCase().contains(query) ||
            eq.type.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  List<BookingModel> getFilteredRentals(String statusFilter) {
    if (statusFilter == 'All') return state.myRentals;
    return state.myRentals.where((b) {
      if (statusFilter == 'Pending' && b.status == 'PENDING') return true;
      if (statusFilter == 'Confirmed' && b.status == 'CONFIRMED') return true;
      if (statusFilter == 'Active' && b.status == 'ACTIVE') return true;
      if (statusFilter == 'Completed' && b.status == 'COMPLETED') return true;
      if (statusFilter == 'Cancelled' && (b.status == 'CANCELLED' || b.status == 'DECLINED' || b.status == 'EXPIRED')) return true;
      return false;
    }).toList();
  }
}
