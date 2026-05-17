import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';

class OrderSystemCubit extends Cubit<OrderSystemState> {
  Timer? _trackingTimer;
  Timer? _assignmentCountdownTimer;
  final Random _random = Random();

  // Simulated static coordinates for tracking (Douala)
  static const double destinationLat = 4.051056;
  static const double destinationLng = 9.767890;
  static const double startLat = 4.062000;
  static const double startLng = 9.752000;

  OrderSystemCubit()
    : super(
        OrderSystemState(
          orders: _generateInitialMockOrders(),
          currentRole: OrderSystemRole.buyer,
        ),
      );

  // ─────────────────────────────────────────────────────────────
  // MOCK DATA — covers all major status scenarios for dev/testing
  // ─────────────────────────────────────────────────────────────
  static List<OrderModel> _generateInitialMockOrders() {
    final now = DateTime.now();
    return [
      // 1. PENDING — buyer can cancel
      OrderModel(
        id: '1',
        orderNumber: 'CMD-FGT9X7R2A',
        status: OrderStatus.pending,
        totalAmount: 45000,
        createdAt: now.subtract(const Duration(minutes: 10)),
        items: [
          CartItem(
            id: 'item_1',
            productId: 'prod_1',
            name: 'Engrais Organique Fertile',
            price: 15000,
            quantity: 2,
            unit: 'Sac 50kg',
            imageUrl: 'https://images.unsplash.com/photo-1593113598332-cd288d649433?auto=format&fit=crop&w=300&q=80',
          ),
          CartItem(
            id: 'item_2',
            productId: 'prod_2',
            name: 'Semences de Maïs Hybride',
            price: 15000,
            quantity: 1,
            unit: 'Sac 5kg',
            imageUrl: 'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Rond-point Deido, Douala',
        paymentMethod: 'MTN_MOMO',
        paymentStatus: 'PENDING',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Deido',
        subtotalAmount: 42000,
        deliveryFee: 3000,
        slug: 'cmd-fgt9x7r2a',
        buyerId: 'buyer_123',
        timeline: {OrderStatus.pending: now.subtract(const Duration(minutes: 10))},
      ),

      // 2. PREPARING — seller preparing, 48h SLA
      OrderModel(
        id: '2',
        orderNumber: 'CMD-FGT5Y3K9B',
        status: OrderStatus.preparing,
        totalAmount: 125000,
        createdAt: now.subtract(const Duration(hours: 4)),
        customerName: 'Aboubakar Njoya',
        items: [
          CartItem(
            id: 'item_3',
            productId: 'prod_3',
            name: 'Motopompe d\'irrigation 3HP',
            price: 125000,
            quantity: 1,
            unit: 'Pièce',
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Bonapriso, Douala',
        paymentMethod: 'ORANGE_MONEY',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Bonapriso',
        subtotalAmount: 120000,
        deliveryFee: 5000,
        slug: 'cmd-fgt5y3k9b',
        buyerId: 'buyer_456',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 4)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(hours: 3, minutes: 45)),
          OrderStatus.preparing: now.subtract(const Duration(hours: 2)),
        },
      ),

      // 3. PAYMENT_CONFIRMED + STORE_PICKUP (cash on pickup)
      OrderModel(
        id: '3',
        orderNumber: 'CMD-FGT7P1M8C',
        status: OrderStatus.paymentConfirmed,
        totalAmount: 75000,
        createdAt: now.subtract(const Duration(hours: 2)),
        customerName: 'Christelle Ekambi',
        items: [
          CartItem(
            id: 'item_4',
            productId: 'prod_4',
            name: 'Pesticide Bio-Protect',
            price: 25000,
            quantity: 3,
            unit: 'Litre',
            imageUrl: 'https://images.unsplash.com/photo-1615811361523-6bd03d7748e7?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        paymentMethod: 'CASH_IN_STORE',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'STORE_PICKUP',
        storeName: 'FGT Agro Boutique Douala',
        storeAddress: 'Boulevard de la Liberté, Akwa',
        subtotalAmount: 75000,
        deliveryFee: 0,
        slug: 'cmd-fgt7p1m8c',
        buyerId: 'buyer_789',
        pickupDeadline: now.add(const Duration(hours: 46)),
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 2)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(hours: 1, minutes: 50)),
        },
      ),

      // 4. DRIVER_ASSIGNED — pending driver acceptance
      OrderModel(
        id: '4',
        orderNumber: 'CMD-FGT8D5N2E',
        status: OrderStatus.driverAssigned,
        totalAmount: 55000,
        createdAt: now.subtract(const Duration(hours: 6)),
        customerName: 'Rodrigue Talla',
        items: [
          CartItem(
            id: 'item_6',
            productId: 'prod_6',
            name: 'Houe à dents forgée',
            price: 8500,
            quantity: 2,
            unit: 'Pièce',
            imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=300&q=80',
          ),
          CartItem(
            id: 'item_7',
            productId: 'prod_7',
            name: 'Pulvérisateur 16L',
            price: 38000,
            quantity: 1,
            unit: 'Pièce',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Makepe, Douala',
        paymentMethod: 'MTN_MOMO',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Makepe',
        subtotalAmount: 55000,
        deliveryFee: 4000,
        slug: 'cmd-fgt8d5n2e',
        buyerId: 'buyer_101',
        driverName: 'Olivier Biya',
        driverPhone: '+237 699 001 122',
        driverId: 'driver_001',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 6)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(hours: 5, minutes: 55)),
          OrderStatus.preparing: now.subtract(const Duration(hours: 4)),
          OrderStatus.driverAssigned: now.subtract(const Duration(minutes: 8)),
        },
      ),

      // 5. OUT_FOR_DELIVERY — buyer can track
      OrderModel(
        id: '5',
        orderNumber: 'CMD-FGT3L6Q0F',
        status: OrderStatus.outForDelivery,
        totalAmount: 32000,
        createdAt: now.subtract(const Duration(hours: 8)),
        customerName: 'Bertrand Nguele',
        items: [
          CartItem(
            id: 'item_8',
            productId: 'prod_8',
            name: 'Bottes de Sécurité Agricole',
            price: 16000,
            quantity: 2,
            unit: 'Paire',
            imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Akwa, Douala',
        paymentMethod: 'BANK_CARD',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Akwa',
        subtotalAmount: 30000,
        deliveryFee: 2000,
        slug: 'cmd-fgt3l6q0f',
        buyerId: 'buyer_123',
        driverName: 'Ebanda Samuel',
        driverPhone: '+237 677 889 900',
        driverId: 'driver_001',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 8)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(hours: 7, minutes: 55)),
          OrderStatus.preparing: now.subtract(const Duration(hours: 6)),
          OrderStatus.driverAssigned: now.subtract(const Duration(hours: 3)),
          OrderStatus.pickedUp: now.subtract(const Duration(hours: 2)),
          OrderStatus.outForDelivery: now.subtract(const Duration(hours: 1)),
        },
      ),

      // 6. DELIVERED — buyer can confirm or dispute
      OrderModel(
        id: '6',
        orderNumber: 'CMD-FGT2M4R7G',
        status: OrderStatus.delivered,
        totalAmount: 68000,
        createdAt: now.subtract(const Duration(days: 1)),
        customerName: 'Fatou Diallo',
        items: [
          CartItem(
            id: 'item_9',
            productId: 'prod_9',
            name: 'Semoir manuel polyvalent',
            price: 68000,
            quantity: 1,
            unit: 'Pièce',
            imageUrl: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Bali, Douala',
        paymentMethod: 'MTN_MOMO',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Bali',
        subtotalAmount: 65000,
        deliveryFee: 3000,
        slug: 'cmd-fgt2m4r7g',
        buyerId: 'buyer_123',
        driverName: 'Ebanda Samuel',
        driverPhone: '+237 677 889 900',
        driverId: 'driver_001',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(days: 1, hours: 2)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(days: 1, hours: 1, minutes: 55)),
          OrderStatus.preparing: now.subtract(const Duration(days: 1, hours: 1)),
          OrderStatus.driverAssigned: now.subtract(const Duration(hours: 22)),
          OrderStatus.pickedUp: now.subtract(const Duration(hours: 20)),
          OrderStatus.outForDelivery: now.subtract(const Duration(hours: 18)),
          OrderStatus.delivered: now.subtract(const Duration(hours: 6)),
        },
      ),

      // 7. COMPLETED — with payout details visible to seller
      OrderModel(
        id: '7',
        orderNumber: 'CMD-FGT4K2L3D',
        status: OrderStatus.completed,
        totalAmount: 32000,
        createdAt: now.subtract(const Duration(days: 3)),
        customerName: 'Isabelle Mfou',
        items: [
          CartItem(
            id: 'item_10',
            productId: 'prod_10',
            name: 'Bottes de Sécurité Agricole',
            price: 16000,
            quantity: 2,
            unit: 'Paire',
            imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Akwa, Douala',
        paymentMethod: 'BANK_CARD',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Akwa',
        subtotalAmount: 30000,
        deliveryFee: 2000,
        slug: 'cmd-fgt4k2l3d',
        buyerId: 'buyer_123',
        driverName: 'Ebanda Samuel',
        driverPhone: '+237 677 889 900',
        driverId: 'driver_001',
        payoutAmount: 28500, // after platform fee
        payoutDate: now.subtract(const Duration(days: 1)),
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(days: 3)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(days: 3)).add(const Duration(minutes: 5)),
          OrderStatus.preparing: now.subtract(const Duration(days: 2, hours: 22)),
          OrderStatus.driverAssigned: now.subtract(const Duration(days: 2, hours: 10)),
          OrderStatus.pickedUp: now.subtract(const Duration(days: 2, hours: 8)),
          OrderStatus.outForDelivery: now.subtract(const Duration(days: 2, hours: 6)),
          OrderStatus.delivered: now.subtract(const Duration(days: 2, hours: 1)),
          OrderStatus.completed: now.subtract(const Duration(days: 2, hours: 1)),
        },
      ),

      // 8. REFUND_REQUESTED — dispute in progress
      OrderModel(
        id: '8',
        orderNumber: 'CMD-FGT1Z9S4H',
        status: OrderStatus.refundRequested,
        totalAmount: 45000,
        createdAt: now.subtract(const Duration(days: 5)),
        customerName: 'Pascal Nkemeni',
        items: [
          CartItem(
            id: 'item_11',
            productId: 'prod_11',
            name: 'Engrais NPK 15-15-15',
            price: 22500,
            quantity: 2,
            unit: 'Sac 25kg',
            imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Bonamoussadi, Douala',
        paymentMethod: 'ORANGE_MONEY',
        paymentStatus: 'CONFIRMED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Bonamoussadi',
        subtotalAmount: 45000,
        deliveryFee: 3500,
        slug: 'cmd-fgt1z9s4h',
        buyerId: 'buyer_123',
        cancellationReason: 'Product damaged on arrival',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(days: 5)),
          OrderStatus.paymentConfirmed: now.subtract(const Duration(days: 5)).add(const Duration(minutes: 5)),
          OrderStatus.preparing: now.subtract(const Duration(days: 4, hours: 20)),
          OrderStatus.outForDelivery: now.subtract(const Duration(days: 4, hours: 10)),
          OrderStatus.delivered: now.subtract(const Duration(days: 4, hours: 2)),
          OrderStatus.refundRequested: now.subtract(const Duration(days: 3)),
        },
      ),

      // 9. CANCELLED_BY_BUYER
      OrderModel(
        id: '9',
        orderNumber: 'CMD-FGT6V8W1J',
        status: OrderStatus.cancelledByBuyer,
        totalAmount: 18000,
        createdAt: now.subtract(const Duration(days: 7)),
        items: [
          CartItem(
            id: 'item_12',
            productId: 'prod_12',
            name: 'Arrosoir 10L inox',
            price: 18000,
            quantity: 1,
            unit: 'Pièce',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=300&q=80',
          ),
        ],
        shippingAddress: 'Logpom, Douala',
        paymentMethod: 'MTN_MOMO',
        paymentStatus: 'REFUNDED',
        deliveryMethod: 'HOME_DELIVERY',
        buyerCity: 'Douala',
        buyerNeighborhood: 'Logpom',
        subtotalAmount: 18000,
        deliveryFee: 2500,
        slug: 'cmd-fgt6v8w1j',
        buyerId: 'buyer_123',
        cancellationReason: 'I changed my mind',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(days: 7)),
          OrderStatus.cancelledByBuyer: now.subtract(const Duration(days: 7)).add(const Duration(minutes: 30)),
        },
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────
  // ROLE
  // ─────────────────────────────────────────────────────────────
  void setRole(OrderSystemRole role) => emit(state.copyWith(currentRole: role));

  void selectOrder(String id) => emit(state.copyWith(selectedOrderId: id));

  // ─────────────────────────────────────────────────────────────
  // ORDER CREATION (from checkout)
  // ─────────────────────────────────────────────────────────────
  void createOrder({
    required List<CartItem> items,
    required String deliveryMethod,
    required String paymentMethod,
    String? shippingAddress,
    String? storeName,
    String? storeAddress,
  }) {
    emit(state.copyWith(isLoading: true));

    for (var item in items) {
      if (item.quantity > 50) {
        emit(state.copyWith(
          isLoading: false,
          error: "${item.name} is not available in the requested quantity.",
        ));
        return;
      }
    }

    final now = DateTime.now();
    final orderNum = 'CMD-FGT${_random.nextInt(900000) + 100000}';
    final subtotal = items.fold<double>(0.0, (v, i) => v + (i.price * i.quantity));
    final deliveryFee = deliveryMethod == 'HOME_DELIVERY' ? 3000.0 : 0.0;

    final newOrder = OrderModel(
      id: now.millisecondsSinceEpoch.toString(),
      orderNumber: orderNum,
      status: OrderStatus.pending,
      totalAmount: subtotal + deliveryFee,
      createdAt: now,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      paymentStatus: 'PENDING',
      deliveryMethod: deliveryMethod,
      buyerCity: 'Douala',
      buyerNeighborhood: shippingAddress?.split(',').last.trim() ?? 'Bénoué',
      storeName: storeName,
      storeAddress: storeAddress,
      subtotalAmount: subtotal,
      deliveryFee: deliveryFee,
      slug: orderNum.toLowerCase(),
      buyerId: 'buyer_123',
      timeline: {OrderStatus.pending: now},
    );

    emit(state.copyWith(
      orders: [newOrder, ...state.orders],
      selectedOrderId: newOrder.id,
      isLoading: false,
      error: null,
    ));
  }

  // ─────────────────────────────────────────────────────────────
  // STATUS TRANSITIONS
  // ─────────────────────────────────────────────────────────────
  void updateOrderStatus(String id, OrderStatus newStatus, {String? reason}) {
    final updatedOrders = state.orders.map((o) {
      if (o.id != id) return o;

      final updatedTimeline = Map<OrderStatus, DateTime>.from(o.timeline)
        ..[newStatus] = DateTime.now();

      String pStatus = o.paymentStatus;
      if (newStatus == OrderStatus.paymentConfirmed) pStatus = 'CONFIRMED';
      if (newStatus == OrderStatus.refunded) pStatus = 'REFUNDED';

      // Assign payout when seller's order is completed
      double? payoutAmount = o.payoutAmount;
      DateTime? payoutDate = o.payoutDate;
      if (newStatus == OrderStatus.completed && payoutAmount == null) {
        payoutAmount = o.subtotalAmount * 0.95; // 5% platform fee
        payoutDate = DateTime.now().add(const Duration(days: 1));
      }

      return o.copyWith(
        status: newStatus,
        paymentStatus: pStatus,
        timeline: updatedTimeline,
        cancellationReason: reason ?? o.cancellationReason,
        payoutAmount: payoutAmount,
        payoutDate: payoutDate,
        driverName: (newStatus == OrderStatus.driverAssigned && o.driverName == null)
            ? 'Ebanda Samuel'
            : o.driverName,
        driverPhone: (newStatus == OrderStatus.driverAssigned && o.driverPhone == null)
            ? '+237 677 889 900'
            : o.driverPhone,
      );
    }).toList();

    emit(state.copyWith(orders: updatedOrders));
  }

  // Buyer cancellation → cancelledByBuyer
  void cancelOrder(String id, String reason) {
    updateOrderStatus(id, OrderStatus.cancelledByBuyer, reason: reason);
  }

  // ─────────────────────────────────────────────────────────────
  // DRIVER ASSIGNMENT — Accept / Decline with 10-min countdown
  // ─────────────────────────────────────────────────────────────
  void triggerDriverAssignment(String orderId) {
    emit(state.copyWith(
      pendingAssignmentOrderId: orderId,
      assignmentSecondsRemaining: 600,
    ));
    _startAssignmentCountdown(orderId);
  }

  void _startAssignmentCountdown(String orderId) {
    _assignmentCountdownTimer?.cancel();
    _assignmentCountdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      final remaining = state.assignmentSecondsRemaining - 1;
      if (remaining <= 0) {
        t.cancel();
        // Auto-decline if driver doesn't respond — re-assign to next driver
        _autoDeclineAssignment(orderId);
      } else {
        emit(state.copyWith(assignmentSecondsRemaining: remaining));
      }
    });
  }

  void acceptAssignment(String orderId) {
    _assignmentCountdownTimer?.cancel();
    emit(state.copyWith(clearPendingAssignment: true));
    updateOrderStatus(orderId, OrderStatus.pickedUp);
  }

  void declineAssignment(String orderId, String reason) {
    _assignmentCountdownTimer?.cancel();
    emit(state.copyWith(clearPendingAssignment: true));
    // In production: backend re-assigns to next available driver
    // For simulation: put back to PREPARING
    updateOrderStatus(orderId, OrderStatus.preparing, reason: 'Driver declined: $reason');
  }

  void _autoDeclineAssignment(String orderId) {
    emit(state.copyWith(clearPendingAssignment: true));
    updateOrderStatus(orderId, OrderStatus.preparing,
        reason: 'Auto-declined (no response in 10 minutes)');
  }

  // ─────────────────────────────────────────────────────────────
  // CUSTOMER ABSENT FLOW — 3 attempts
  // ─────────────────────────────────────────────────────────────
  void recordDeliveryAttempt(String orderId) {
    final current = state.absentAttempts[orderId] ?? 0;
    final newAttempts = Map<String, int>.from(state.absentAttempts)
      ..[orderId] = current + 1;

    if (current + 1 >= 3) {
      // 3rd failed attempt → DELIVERY_FAILED
      updateOrderStatus(orderId, OrderStatus.deliveryFailed,
          reason: 'Delivery failed after 3 attempts — customer absent');
      emit(state.copyWith(absentAttempts: newAttempts));
    } else {
      emit(state.copyWith(absentAttempts: newAttempts));
    }
  }

  int getAbsentAttempts(String orderId) => state.absentAttempts[orderId] ?? 0;

  // ─────────────────────────────────────────────────────────────
  // GPS TRACKING SIMULATION
  // ─────────────────────────────────────────────────────────────
  void startTrackingSimulation() {
    _trackingTimer?.cancel();

    emit(state.copyWith(
      driverLatitude: startLat,
      driverLongitude: startLng,
      driverHeading: 45.0,
      trackingMinutesRemaining: 15,
      trackingDistanceRemaining: 2.4,
      isTrackingActive: true,
    ));

    int step = 0;
    const int totalSteps = 20;

    _trackingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      step++;
      if (step >= totalSteps) {
        timer.cancel();
        emit(state.copyWith(
          driverLatitude: destinationLat,
          driverLongitude: destinationLng,
          trackingMinutesRemaining: 0,
          trackingDistanceRemaining: 0.0,
          isTrackingActive: false,
        ));
        if (state.selectedOrderId != null) {
          updateOrderStatus(state.selectedOrderId!, OrderStatus.delivered);
        }
      } else {
        final double t = step / totalSteps;
        final double lat = startLat + (destinationLat - startLat) * t;
        final double lng = startLng + (destinationLng - startLng) * t;
        final double distance = 2.4 * (1.0 - t);
        final int minutes = (15 * (1.0 - t)).round();

        final double dLon = destinationLng - startLng;
        final double y = sin(dLon) * cos(destinationLat);
        final double x = cos(startLat) * sin(destinationLat) -
            sin(startLat) * cos(destinationLat) * cos(dLon);
        final double heading = (atan2(y, x) * 180 / pi + 360) % 360;

        emit(state.copyWith(
          driverLatitude: lat,
          driverLongitude: lng,
          driverHeading: heading,
          trackingMinutesRemaining: minutes,
          trackingDistanceRemaining: distance,
        ));
      }
    });
  }

  void stopTrackingSimulation() {
    _trackingTimer?.cancel();
    emit(state.copyWith(isTrackingActive: false));
  }

  @override
  Future<void> close() {
    _trackingTimer?.cancel();
    _assignmentCountdownTimer?.cancel();
    return super.close();
  }
}
