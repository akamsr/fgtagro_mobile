import 'package:equatable/equatable.dart';
import 'package:fgtagro_mobile/models/order.dart';

enum OrderSystemRole { buyer, seller, driver, storeManager }

class OrderSystemState extends Equatable {
  final List<OrderModel> orders;
  final OrderSystemRole currentRole;
  final bool isLoading;
  final String? error;
  final String? selectedOrderId;

  // Simulated Real-Time tracking state
  final double? driverLatitude;
  final double? driverLongitude;
  final double? driverHeading;
  final int? trackingMinutesRemaining;
  final double? trackingDistanceRemaining;
  final bool isTrackingActive;

  // Driver assignment pending-acceptance state
  final String? pendingAssignmentOrderId;
  final int assignmentSecondsRemaining; // 600 → 0

  // Customer-absent attempt tracking
  final Map<String, int> absentAttempts; // orderId → attempt count (0–3)

  const OrderSystemState({
    required this.orders,
    required this.currentRole,
    this.isLoading = false,
    this.error,
    this.selectedOrderId,
    this.driverLatitude,
    this.driverLongitude,
    this.driverHeading,
    this.trackingMinutesRemaining,
    this.trackingDistanceRemaining,
    this.isTrackingActive = false,
    this.pendingAssignmentOrderId,
    this.assignmentSecondsRemaining = 600,
    this.absentAttempts = const {},
  });

  OrderSystemState copyWith({
    List<OrderModel>? orders,
    OrderSystemRole? currentRole,
    bool? isLoading,
    String? error,
    String? selectedOrderId,
    double? driverLatitude,
    double? driverLongitude,
    double? driverHeading,
    int? trackingMinutesRemaining,
    double? trackingDistanceRemaining,
    bool? isTrackingActive,
    String? pendingAssignmentOrderId,
    bool clearPendingAssignment = false,
    int? assignmentSecondsRemaining,
    Map<String, int>? absentAttempts,
  }) {
    return OrderSystemState(
      orders: orders ?? this.orders,
      currentRole: currentRole ?? this.currentRole,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
      driverLatitude: driverLatitude ?? this.driverLatitude,
      driverLongitude: driverLongitude ?? this.driverLongitude,
      driverHeading: driverHeading ?? this.driverHeading,
      trackingMinutesRemaining:
          trackingMinutesRemaining ?? this.trackingMinutesRemaining,
      trackingDistanceRemaining:
          trackingDistanceRemaining ?? this.trackingDistanceRemaining,
      isTrackingActive: isTrackingActive ?? this.isTrackingActive,
      pendingAssignmentOrderId: clearPendingAssignment
          ? null
          : pendingAssignmentOrderId ?? this.pendingAssignmentOrderId,
      assignmentSecondsRemaining:
          assignmentSecondsRemaining ?? this.assignmentSecondsRemaining,
      absentAttempts: absentAttempts ?? this.absentAttempts,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        currentRole,
        isLoading,
        error,
        selectedOrderId,
        driverLatitude,
        driverLongitude,
        driverHeading,
        trackingMinutesRemaining,
        trackingDistanceRemaining,
        isTrackingActive,
        pendingAssignmentOrderId,
        assignmentSecondsRemaining,
        absentAttempts,
      ];
}
