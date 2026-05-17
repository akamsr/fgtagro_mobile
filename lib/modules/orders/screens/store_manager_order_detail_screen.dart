import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class StoreManagerOrderDetailScreen extends StatefulWidget {
  final String orderId;
  const StoreManagerOrderDetailScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<StoreManagerOrderDetailScreen> createState() =>
      _StoreManagerOrderDetailScreenState();
}

class _StoreManagerOrderDetailScreenState
    extends State<StoreManagerOrderDetailScreen> {
  late List<bool> _itemChecks;
  bool _qrScanning = false;
  bool _qrValidated = false;
  bool _showCashScreen = false;
  final TextEditingController _cashController = TextEditingController();
  bool _cashAmountValid = false;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSystemCubit, OrderSystemState>(
      builder: (context, state) {
        final order = state.orders.firstWhere(
          (o) => o.id == widget.orderId,
          orElse: () => state.orders.first,
        );

        _itemChecks = _itemChecks.length == order.items.length
            ? _itemChecks
            : List.generate(order.items.length, (_) => false);

        return Scaffold(
          backgroundColor: const Color(0xFFF9F7FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.secondaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Store Pickup Order',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: _showCashScreen
              ? _buildCashCollectionScreen(context, order)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderHeader(order),
                      const SizedBox(height: 16),
                      _buildProductChecklist(order),
                      const SizedBox(height: 16),
                      _buildCustomerBlock(order),
                      const SizedBox(height: 16),
                      _buildPickupDeadlineBlock(order),
                      const SizedBox(height: 24),
                      _buildActions(context, order),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ─── Order Header ───────────────────────────────────────────────
  Widget _buildOrderHeader(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ORDER',
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.secondaryColor),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.paymentMethod ?? 'MOBILE_MONEY',
                  style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL AMOUNT',
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    '${order.totalAmount.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.primaryColor),
                  ),
                ],
              ),
              if (order.paymentMethod == 'CASH_IN_STORE')
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Collect Cash',
                        style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Product Checklist ──────────────────────────────────────────
  Widget _buildProductChecklist(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRODUCTS TO PREPARE',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, i) {
              final item = order.items[i];
              return Row(
                children: [
                  Checkbox(
                    value: _itemChecks.length > i ? _itemChecks[i] : false,
                    onChanged: order.status == OrderStatus.paymentConfirmed
                        ? (v) => setState(() => _itemChecks[i] = v ?? false)
                        : null,
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.secondaryColor)),
                        Text('${item.quantity}× ${item.unit}',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Customer Block ─────────────────────────────────────────────
  Widget _buildCustomerBlock(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CUSTOMER',
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(height: 2),
              Text(
                order.customerName?.split(' ').first ??
                    order.buyerCity ??
                    'Customer',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              if (order.buyerCity != null)
                Text(
                  '${order.buyerNeighborhood ?? ''}, ${order.buyerCity}',
                  style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Pickup Deadline Block ──────────────────────────────────────
  Widget _buildPickupDeadlineBlock(OrderModel order) {
    final deadline = order.pickupDeadline ??
        order.createdAt.add(const Duration(hours: 48));
    final remaining = deadline.difference(DateTime.now());
    final hours = remaining.inHours;
    final Color timerColor = hours > 24
        ? Colors.green
        : hours > 6
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: timerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PICKUP DEADLINE',
              style: TextStyle(
                  color: timerColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, color: timerColor, size: 24),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${hours.abs()}h ${remaining.inMinutes.remainder(60)}m remaining',
                    style: TextStyle(
                        color: timerColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    'Customer must collect by ${_formatDeadline(deadline)}',
                    style: TextStyle(
                        color: timerColor.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime dt) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month]} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // ─── Actions ────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context, OrderModel order) {
    final allChecked = _itemChecks.every((c) => c);

    if (order.status == OrderStatus.paymentConfirmed) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: allChecked
                  ? () {
                      context.read<OrderSystemCubit>().updateOrderStatus(
                            widget.orderId,
                            OrderStatus.readyForPickup,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Order marked Ready for Pickup! Customer has been notified.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                disabledBackgroundColor:
                    AppColors.primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Mark as Ready for Pickup',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ),
          ),
          if (!allChecked)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Check all items above to enable this button',
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    }

    if (order.status == OrderStatus.readyForPickup ||
        order.status == OrderStatus.preparing) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text('Scan Customer QR Code',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                _simulateQrScan(context, order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_qrValidated) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Customer QR validated ✓',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: order.paymentMethod == 'CASH_IN_STORE'
                          ? () => setState(() => _showCashScreen = true)
                          : () {
                              context
                                  .read<OrderSystemCubit>()
                                  .updateOrderStatus(
                                    widget.orderId,
                                    OrderStatus.delivered,
                                  );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Pickup confirmed ✓ Thank you for using FGT AGRO!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        order.paymentMethod == 'CASH_IN_STORE'
                            ? 'Collect Cash & Release'
                            : 'Confirm & Release Order ✓',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _simulateQrScan(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Scanning QR Code...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Validating customer QR...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() => _qrValidated = true);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('QR Validated!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${order.customerName?.split(' ').first ?? 'Verified'}'),
              const SizedBox(height: 8),
              Text('${order.items.length} item(s) to hand over'),
              if (order.paymentMethod == 'CASH_IN_STORE') ...[
                const SizedBox(height: 8),
                Text(
                  'Collect: ${order.totalAmount.toStringAsFixed(0)} FCFA cash',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              child: const Text('Confirmed', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    });
  }

  // ─── Cash Collection Screen ─────────────────────────────────────
  Widget _buildCashCollectionScreen(
      BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.payments_outlined,
              color: AppColors.primaryColor, size: 64),
          const SizedBox(height: 16),
          const Text(
            'AMOUNT TO COLLECT',
            style: TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${order.totalAmount.toStringAsFixed(0)} FCFA',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'AMOUNT RECEIVED FROM CUSTOMER',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _cashController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '0',
              filled: true,
              fillColor: Colors.white,
              suffix: const Text('FCFA',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _cashAmountValid
                      ? Colors.green
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _cashAmountValid ? Colors.green : Colors.blue,
                  width: 2,
                ),
              ),
              errorText: _cashController.text.isNotEmpty && !_cashAmountValid
                  ? 'Amount does not match. Order total is ${order.totalAmount.toStringAsFixed(0)} FCFA'
                  : null,
            ),
            onChanged: (val) {
              final entered =
                  double.tryParse(val.replaceAll(',', '')) ?? 0;
              setState(
                  () => _cashAmountValid = entered == order.totalAmount);
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _cashAmountValid
                  ? () {
                      context.read<OrderSystemCubit>().updateOrderStatus(
                            widget.orderId,
                            OrderStatus.delivered,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Cash received ✓ Pickup confirmed!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Confirm Cash Received & Release Order',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(() => _showCashScreen = false),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
