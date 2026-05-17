import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';

class OrderSystemCubit extends Cubit<OrderSystemState> {
  Timer? _trackingTimer;
  final Random _random = Random();

  // Simulated static coordinates for tracking
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

  static List<OrderModel> _generateInitialMockOrders() {
    final now = DateTime.now();
    return [
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
            imageUrl:
                'https://images.unsplash.com/photo-1593113598332-cd288d649433?auto=format&fit=crop&w=300&q=80',
          ),
          CartItem(
            id: 'item_2',
            productId: 'prod_2',
            name: 'Semences de Maïs Hybride',
            price: 15000,
            quantity: 1,
            unit: 'Sac 5kg',
            imageUrl:
                'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?auto=format&fit=crop&w=300&q=80',
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
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(minutes: 10)),
        },
      ),
      OrderModel(
        id: '2',
        orderNumber: 'CMD-FGT5Y3K9B',
        status: OrderStatus.preparing,
        totalAmount: 125000,
        createdAt: now.subtract(const Duration(hours: 4)),
        items: [
          CartItem(
            id: 'item_3',
            productId: 'prod_3',
            name: 'Motopompe d\'irrigation 3HP',
            price: 125000,
            quantity: 1,
            unit: 'Pièce',
            imageUrl:
                'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=300&q=80',
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
        buyerId: 'buyer_123',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 4)),
          OrderStatus.paymentConfirmed: now.subtract(
            const Duration(hours: 3, minutes: 45),
          ),
        },
      ),
      OrderModel(
        id: '3',
        orderNumber: 'CMD-FGT7P1M8C',
        status: OrderStatus.paymentConfirmed,
        totalAmount: 75000,
        createdAt: now.subtract(const Duration(hours: 2)),
        items: [
          CartItem(
            id: 'item_4',
            productId: 'prod_4',
            name: 'Pesticide Bio-Protect',
            price: 25000,
            quantity: 3,
            unit: 'Litre',
            imageUrl:
                'https://images.unsplash.com/photo-1615811361523-6bd03d7748e7?auto=format&fit=crop&w=300&q=80',
            qty: null,
            businessId: null,
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
        buyerId: 'buyer_123',
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(hours: 2)),
          OrderStatus.paymentConfirmed: now.subtract(
            const Duration(hours: 1, minutes: 50),
          ),
        },
      ),
      OrderModel(
        id: '4',
        orderNumber: 'CMD-FGT4K2L3D',
        status: OrderStatus.completed,
        totalAmount: 32000,
        createdAt: now.subtract(const Duration(days: 3)),
        items: [
          CartItem(
            id: 'item_5',
            productId: 'prod_5',
            name: 'Bottes de Sécurité Agricole',
            price: 16000,
            quantity: 2,
            unit: 'Paire',
            imageUrl:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=300&q=80',
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
        timeline: {
          OrderStatus.pending: now.subtract(const Duration(days: 3)),
          OrderStatus.paymentConfirmed: now.subtract(
            const Duration(days: 3).add(const Duration(minutes: 5)),
          ),
          OrderStatus.preparing: now.subtract(
            const Duration(days: 2, hours: 22),
          ),
          OrderStatus.shipped: now.subtract(const Duration(days: 2, hours: 20)),
          OrderStatus.delivered: now.subtract(
            const Duration(days: 2, hours: 19),
          ),
          OrderStatus.completed: now.subtract(
            const Duration(days: 2, hours: 1),
          ),
        },
      ),
    ];
  }

  void setRole(OrderSystemRole role) {
    emit(state.copyWith(currentRole: role));
  }

  void selectOrder(String id) {
    emit(state.copyWith(selectedOrderId: id));
  }

  // Phase 1: Simulate creating a new order from cart items
  void createOrder({
    required List<CartItem> items,
    required String deliveryMethod,
    required String paymentMethod,
    String? shippingAddress,
    String? storeName,
    String? storeAddress,
  }) {
    emit(state.copyWith(isLoading: true));

    // Simulate stock check
    for (var item in items) {
      if (item.quantity > 50) {
        emit(
          state.copyWith(
            isLoading: false,
            error:
                "${item.name} n'est plus disponible dans la quantité demandée.",
          ),
        );
        return;
      }
    }

    final now = DateTime.now();
    final randomNum = 'CMD-FGT${_random.nextInt(900000) + 100000}';
    final subtotal = items.fold<double>(
      0.0,
      (val, item) => val + (item.price * item.quantity),
    );
    final deliveryFee = deliveryMethod == 'HOME_DELIVERY' ? 3000.0 : 0.0;

    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: randomNum,
      status: OrderStatus.pending,
      totalAmount: subtotal + deliveryFee,
      createdAt: now,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      paymentStatus: 'PENDING',
      deliveryMethod: deliveryMethod,
      buyerCity: 'Douala',
      buyerNeighborhood: shippingAddress != null
          ? shippingAddress.split(',').last.trim()
          : 'Bénoué',
      storeName: storeName,
      storeAddress: storeAddress,
      subtotalAmount: subtotal,
      deliveryFee: deliveryFee,
      slug: randomNum.toLowerCase(),
      buyerId: 'buyer_123',
      timeline: {OrderStatus.pending: now},
    );

    final updatedOrders = [newOrder, ...state.orders];
    emit(
      state.copyWith(
        orders: updatedOrders,
        selectedOrderId: newOrder.id,
        isLoading: false,
        error: null,
      ),
    );
  }

  // Simulate general status changes according to the state machine
  void updateOrderStatus(String id, OrderStatus newStatus, {String? reason}) {
    final updatedOrders = state.orders.map((o) {
      if (o.id == id) {
        final Map<OrderStatus, DateTime> updatedTimeline = Map.from(o.timeline);
        updatedTimeline[newStatus] = DateTime.now();

        // Map order fields based on status transitions
        String pStatus = o.paymentStatus;
        if (newStatus == OrderStatus.paymentConfirmed) {
          pStatus = 'CONFIRMED';
        }

        return OrderModel(
          id: o.id,
          orderNumber: o.orderNumber,
          status: newStatus,
          totalAmount: o.totalAmount,
          createdAt: o.createdAt,
          items: o.items,
          shippingAddress: o.shippingAddress,
          paymentMethod: o.paymentMethod,
          paymentStatus: pStatus,
          deliveryMethod: o.deliveryMethod,
          buyerCity: o.buyerCity,
          buyerNeighborhood: o.buyerNeighborhood,
          driverName: newStatus == OrderStatus.preparing
              ? 'Ebanda Samuel'
              : o.driverName,
          driverPhone: newStatus == OrderStatus.preparing
              ? '+237 677 889 900'
              : o.driverPhone,
          storeName: o.storeName,
          storeAddress: o.storeAddress,
          timeline: updatedTimeline,
          cancellationReason: reason ?? o.cancellationReason,
          payoutAmount: o.payoutAmount,
          payoutDate: o.payoutDate,
          slug: o.slug,
          buyerId: o.buyerId,
          subtotalAmount: o.subtotalAmount,
          deliveryFee: o.deliveryFee,
        );
      }
      return o;
    }).toList();

    emit(state.copyWith(orders: updatedOrders));
  }

  // Cancellation flow
  void cancelOrder(String id, String reason) {
    updateOrderStatus(id, OrderStatus.cancelled, reason: reason);
  }

  // Real-Time live simulation of Driver tracking
  void startTrackingSimulation() {
    if (_trackingTimer != null) {
      _trackingTimer!.cancel();
    }

    emit(
      state.copyWith(
        driverLatitude: startLat,
        driverLongitude: startLng,
        driverHeading: 45.0,
        trackingMinutesRemaining: 15,
        trackingDistanceRemaining: 2.4,
        isTrackingActive: true,
      ),
    );

    int currentStep = 0;
    const int totalSteps = 20;

    _trackingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      currentStep++;
      if (currentStep >= totalSteps) {
        timer.cancel();
        emit(
          state.copyWith(
            driverLatitude: destinationLat,
            driverLongitude: destinationLng,
            trackingMinutesRemaining: 0,
            trackingDistanceRemaining: 0.0,
            isTrackingActive: false,
          ),
        );

        // Auto-deliver order
        if (state.selectedOrderId != null) {
          updateOrderStatus(state.selectedOrderId!, OrderStatus.delivered);
        }
      } else {
        final double t = currentStep / totalSteps;
        final double lat = startLat + (destinationLat - startLat) * t;
        final double lng = startLng + (destinationLng - startLng) * t;
        final double distance = 2.4 * (1.0 - t);
        final int minutes = (15 * (1.0 - t)).round();

        // Calculate heading/bearing
        final double dLon = (destinationLng - startLng);
        final double y = sin(dLon) * cos(destinationLat);
        final double x =
            cos(startLat) * sin(destinationLat) -
            sin(startLat) * cos(destinationLat) * cos(dLon);
        final double heading = (atan2(y, x) * 180 / pi + 360) % 360;

        emit(
          state.copyWith(
            driverLatitude: lat,
            driverLongitude: lng,
            driverHeading: heading,
            trackingMinutesRemaining: minutes,
            trackingDistanceRemaining: distance,
          ),
        );
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
    return super.close();
  }
}
