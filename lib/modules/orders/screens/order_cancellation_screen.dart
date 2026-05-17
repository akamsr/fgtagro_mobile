import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class OrderCancellationScreen extends StatefulWidget {
  final String orderId;
  const OrderCancellationScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<OrderCancellationScreen> createState() =>
      _OrderCancellationScreenState();
}

class _OrderCancellationScreenState extends State<OrderCancellationScreen> {
  String? _selectedReason;
  final TextEditingController _otherController = TextEditingController();
  bool _isLoading = false;

  final List<String> _reasons = [
    'I changed my mind',
    'I ordered the wrong product',
    'I found a better price elsewhere',
    'Delivery time is too long',
    'Other',
  ];

  bool get _canSubmit {
    if (_selectedReason == null) return false;
    if (_selectedReason == 'Other' && _otherController.text.trim().length < 20) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _otherController.dispose();
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

        return Scaffold(
          backgroundColor: const Color(0xFFF9F7FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.secondaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Cancel this order?',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummaryCard(order),
                const SizedBox(height: 20),
                _buildReasonSelector(),
                const SizedBox(height: 20),
                _buildRefundInfoBox(order),
                const SizedBox(height: 28),
                _buildActionButtons(context, order),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummaryCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(order.createdAt),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 20),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${item.quantity}× ${item.name}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              )),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${order.totalAmount.toStringAsFixed(0)} FCFA',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHY ARE YOU CANCELLING?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedReason,
              isExpanded: true,
              hint: const Text('Select a reason...'),
              items: _reasons
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedReason = val),
            ),
          ),
        ),
        if (_selectedReason == 'Other') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _otherController,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText:
                  'Please describe your reason (minimum 20 characters)...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              counterText:
                  '${_otherController.text.trim().length}/20 min',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRefundInfoBox(OrderModel order) {
    String refundMessage;
    String method = order.paymentMethod ?? 'MOBILE_MONEY';

    if (method.contains('MOMO') || method.contains('ORANGE') || method.contains('CARD')) {
      refundMessage =
          'Your refund of ${order.totalAmount.toStringAsFixed(0)} FCFA will be processed within 24 hours to your ${method.replaceAll('_', ' ')} account.';
    } else if (method.contains('BANK_TRANSFER')) {
      refundMessage =
          'Your refund of ${order.totalAmount.toStringAsFixed(0)} FCFA will be processed within 48 hours via bank transfer.';
    } else {
      refundMessage =
          'Your refund of ${order.totalAmount.toStringAsFixed(0)} FCFA will be processed within 24 hours.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              refundMessage,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderModel order) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _canSubmit && !_isLoading
                ? () async {
                    setState(() => _isLoading = true);
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (!mounted) return;
                    final reason = _selectedReason == 'Other'
                        ? _otherController.text.trim()
                        : _selectedReason!;
                    context
                        .read<OrderSystemCubit>()
                        .cancelOrder(widget.orderId, reason);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Order ${order.orderNumber} cancelled. Refund being processed.'),
                        backgroundColor: Colors.red.shade600,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              disabledBackgroundColor: Colors.red.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Cancel order',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Keep my order',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
