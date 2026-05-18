import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/modules/business/rental/cubit/rental.state.dart';

class RentalCubit extends Cubit<RentalState> {
  RentalCubit() : super(RentalState());

  void fetchAllData() async {
    emit(state.copyWith(genLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    final mockEquipment = [
      EquipmentModel(
        id: '1',
        type: 'Tractor',
        brand: 'John Deere',
        model: '5075E',
        yearOfManufacture: 2022,
        dailyRate: 75000,
        securityDeposit: 150000,
        fuelPolicy: 'Full-to-full',
        status: 'PUBLISHED',
        isAvailable: true,
        photoSlots: {'front': 'https://example.com/tractor_front.jpg'},
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
        id: 'b1',
        equipment: mockEquipment[0],
        tenant: mockUser,
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        totalAmount: 225000,
        status: 'PENDING',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      BookingModel(
        id: 'b2',
        equipment: mockEquipment[0],
        tenant: mockUser,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 1)),
        totalAmount: 150000,
        status: 'ACTIVE',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    final mockHistory = [
      BookingModel(
        id: 'h1',
        equipment: mockEquipment[0],
        tenant: mockUser,
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 7)),
        totalAmount: 225000,
        status: 'COMPLETED',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];

    emit(
      state.copyWith(
        genLoading: false,
        equipment: mockEquipment,
        bookings: mockBookings,
        history: mockHistory,
      ),
    );
  }

  void updateEquipmentStatus(String id, String newStatus) {
    final updatedList = state.equipment.map((e) {
      if (e.id == id) {
        // In a real app, this would be an API call
        // return e.copyWith(status: newStatus);
        // For now, we'll just emit a new list with the updated item
        return EquipmentModel.fromJson({...e.toJson(), 'status': newStatus});
      }
      return e;
    }).toList();
    emit(state.copyWith(equipment: updatedList));
  }
}
