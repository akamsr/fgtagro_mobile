import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen Driver Assignment modal with 10-minute countdown.
/// Shows order summary, earnings estimate, and Accept / Decline buttons.
@RoutePage()
class DriverAssignmentScreen extends StatefulWidget {
  final String orderId;
  const DriverAssignmentScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<DriverAssignmentScreen> createState() => _DriverAssignmentScreenState();
}

class _DriverAssignmentScreenState extends State<DriverAssignmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<String> _declineReasons = [
    'Too far from pickup location',
    'Vehicle issue',
    'Already have another delivery',
    'Personal emergency',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Trigger the countdown in the cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderSystemCubit>().triggerDriverAssignment(widget.orderId);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderSystemCubit, OrderSystemState>(
      listener: (context, state) {
        // Auto-close if assignment cleared (timeout or decline)
        if (state.pendingAssignmentOrderId == null) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final order = state.orders.firstWhere(
          (o) => o.id == widget.orderId,
          orElse: () => state.orders.first,
        );

        final remaining = state.assignmentSecondsRemaining;
        final urgentColor = remaining <= 120 ? Colors.red : AppColors.primaryColor;

        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.9),
          body: SafeArea(
            child: Column(
              children: [
                // Timer section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                        'NEW DELIVERY REQUEST',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ScaleTransition(
                        scale: _pulseAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: urgentColor, width: 4),
                            color: urgentColor.withOpacity(0.15),
                          ),
                          child: Center(
                            child: Text(
                              _formatTime(remaining),
                              style: TextStyle(
                                color: urgentColor,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'to respond',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Order details card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          icon: Icons.confirmation_number_outlined,
                          label: 'Order',
                          value: order.orderNumber,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          icon: Icons.store_outlined,
                          label: 'Pickup',
                          value: '${order.buyerNeighborhood ?? "Seller location"}, ${order.buyerCity ?? "Douala"}',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Delivery',
                          value: order.shippingAddress ?? 'Customer address',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          icon: Icons.inventory_2_outlined,
                          label: 'Items',
                          value: '${order.items.length} product(s)',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.payments_outlined,
                          label: 'Delivery fee',
                          value: '${order.deliveryFee.toStringAsFixed(0)} FCFA',
                          valueColor: AppColors.primaryColor,
                          valueBold: true,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Estimated earnings',
                          value: '${(order.deliveryFee * 0.80).toStringAsFixed(0)} FCFA (80%)',
                          valueColor: Colors.green,
                          valueBold: true,
                        ),
                        const Spacer(),

                        // Accept / Decline
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => _showDeclineDialog = true);
                                  _showDeclineSheet(context, order);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<OrderSystemCubit>()
                                      .acceptAssignment(widget.orderId);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Assignment accepted! Head to pickup location.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  'Accept ✓',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.secondaryColor,
                  fontSize: 14,
                  fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeclineSheet(BuildContext context, OrderModel order) {
    String? selected;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Why are you declining?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor),
              ),
              const SizedBox(height: 16),
              ..._declineReasons.map(
                (r) => RadioListTile<String>(
                  value: r,
                  groupValue: selected,
                  onChanged: (v) => setModalState(() => selected = v),
                  title: Text(r, style: const TextStyle(fontSize: 14)),
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selected != null
                      ? () {
                          Navigator.pop(ctx);
                          context.read<OrderSystemCubit>().declineAssignment(
                                widget.orderId,
                                selected!,
                              );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm Decline',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Customer Absent Flow — tracks attempts and lets driver log each one.
@RoutePage()
class CustomerAbsentScreen extends StatefulWidget {
  final String orderId;
  const CustomerAbsentScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<CustomerAbsentScreen> createState() => _CustomerAbsentScreenState();
}

class _CustomerAbsentScreenState extends State<CustomerAbsentScreen> {
  bool _waitingTimer = false;
  int _waitSeconds = 0;
  Timer? _waitTimer;

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  void _startWaitTimer(int seconds) {
    setState(() {
      _waitingTimer = true;
      _waitSeconds = seconds;
    });
    _waitTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_waitSeconds <= 1) {
        t.cancel();
        setState(() => _waitingTimer = false);
      } else {
        setState(() => _waitSeconds--);
      }
    });
  }

  String _formatWait(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m}m ${sec.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSystemCubit, OrderSystemState>(
      builder: (context, state) {
        final order = state.orders.firstWhere(
          (o) => o.id == widget.orderId,
          orElse: () => state.orders.first,
        );
        final attempts = state.absentAttempts[widget.orderId] ?? 0;
        final isFailed = order.status == OrderStatus.deliveryFailed;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F7FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.secondaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Customer Absent',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.orderNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${order.buyerNeighborhood ?? ""}, ${order.buyerCity ?? ""}',
                              style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (order.shippingAddress != null)
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                order.shippingAddress!,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Attempt indicators
                const Text(
                  'DELIVERY ATTEMPTS',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(3, (i) {
                    final done = i < attempts;
                    final isNext = i == attempts;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: done
                                ? Colors.red.shade50
                                : isNext
                                    ? AppColors.primaryColor.withOpacity(0.08)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: done
                                  ? Colors.red.shade200
                                  : isNext
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade200,
                              width: isNext ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                done
                                    ? Icons.close
                                    : isNext
                                        ? Icons.person_search
                                        : Icons.radio_button_unchecked,
                                color: done
                                    ? Colors.red
                                    : isNext
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade400,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Attempt ${i + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isNext
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: done
                                      ? Colors.red
                                      : isNext
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade400,
                                ),
                              ),
                              if (done)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Customer absent',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Wait timer instructions by attempt
                if (!isFailed) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.blue.shade600, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Attempt ${attempts + 1} of 3',
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          attempts == 0
                              ? 'Call the customer (number masked by system). Wait 15 minutes at the delivery address before logging a failed attempt.'
                              : attempts == 1
                                  ? 'Wait at least 2 hours before logging this attempt. If customer is still absent, this will be your final attempt.'
                                  : 'This is your 3rd and final attempt. If customer is still absent, the order will be marked as DELIVERY_FAILED and you can return the package.',
                          style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 13,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Wait timer button
                  if (!_waitingTimer)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.timer_outlined),
                        label: Text(
                          attempts == 0
                              ? 'Start 15-min wait timer'
                              : 'Start 2-hour wait timer',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () =>
                            _startWaitTimer(attempts == 0 ? 900 : 7200),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.hourglass_bottom,
                              color: Colors.orange),
                          const SizedBox(width: 10),
                          Text(
                            'Wait time remaining: ${_formatWait(_waitSeconds)}',
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Log failed attempt
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_off_outlined,
                          color: Colors.white),
                      label: Text(
                        attempts < 2
                            ? 'Log failed attempt (${attempts + 1}/3)'
                            : 'Mark as DELIVERY FAILED',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        context
                            .read<OrderSystemCubit>()
                            .recordDeliveryAttempt(widget.orderId);
                        if (attempts >= 2) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Order marked DELIVERY_FAILED after 3 attempts. Please return the package.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Attempt ${attempts + 1} logged. ${2 - attempts} attempt(s) remaining.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            attempts < 2 ? Colors.orange : Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],

                // DELIVERY FAILED state
                if (isFailed) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.cancel_outlined, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Delivery Failed',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'All 3 delivery attempts have been exhausted. Please return the package to the seller. The buyer will receive a full refund.',
                          style: TextStyle(
                              color: Colors.red, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Return to deliveries',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
