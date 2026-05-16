import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@RoutePage()
class SellerOrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const SellerOrderDetailScreen({super.key, required this.order});

  @override
  State<SellerOrderDetailScreen> createState() =>
      _SellerOrderDetailScreenState();
}

class _SellerOrderDetailScreenState extends State<SellerOrderDetailScreen> {
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'FCFA',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text(
          S.of(context).details,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderBlock(currencyFormatter),
            _buildProductsBlock(currencyFormatter),
            _buildBuyerBlock(),
            _buildDeliveryBlock(),
            _buildTimelineBlock(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildActionBottomBar(),
    );
  }

  Widget _buildHeaderBlock(NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${_order.orderNumber}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              _buildStatusBadge(_order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMM yyyy, HH:mm').format(_order.createdAt),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const Divider(height: 32),
          Row(
            children: [
              _buildInfoItem(
                S.of(context).paymentMethod,
                _order.paymentMethod ?? 'FGT Wallet',
              ),
              const Spacer(),
              _buildInfoItem(
                S.of(context).paymentStatus,
                _order.paymentStatus,
                isHighlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isHighlight
                ? Colors.green.shade700
                : AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsBlock(NumberFormat formatter) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderItems,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ..._order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? 'Product Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${item.qty} x ${formatter.format(item.finalPrice)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatter.format((item.finalPrice) * (item.qty)),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                formatter.format(_order.totalAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerBlock() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).buyer,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                '${_order.buyerCity ?? 'Yaoundé'}, ${_order.buyerNeighborhood ?? 'Bastos'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Exact address hidden for privacy. Reveal to driver only.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryBlock() {
    final bool isHome = _order.deliveryMethod == 'HOME_DELIVERY';
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).delivery,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (isHome) ...[
            if (_order.driverName != null)
              _buildDeliveryInfoItem(
                Icons.person_outline,
                _order.driverName!,
                _order.driverPhone!,
              )
            else
              Text(
                S.of(context).waitingDriver,
                style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
              ),
          ] else ...[
            _buildDeliveryInfoItem(
              Icons.storefront,
              _order.storeName ?? 'Main Warehouse',
              _order.storeAddress ?? 'City Center',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineBlock() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).statusTimeline,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildTimelineItem(
            'PAYMENT_CONFIRMED',
            _order.timeline[OrderStatus.paymentConfirmed],
            isFirst: true,
          ),
          _buildTimelineItem(
            'PREPARING',
            _order.timeline[OrderStatus.preparing],
          ),
          _buildTimelineItem('SHIPPED', _order.timeline[OrderStatus.shipped]),
          _buildTimelineItem(
            'DELIVERED',
            _order.timeline[OrderStatus.delivered],
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String label,
    DateTime? date, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final bool isDone = date != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primaryColor : Colors.grey.shade300,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppColors.primaryColor : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.replaceAll('_', ' '),
                style: TextStyle(
                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                  color: isDone ? AppColors.secondaryColor : Colors.grey,
                  fontSize: 14,
                ),
              ),
              if (isDone)
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(date),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBottomBar() {
    Widget? content;
    Color? bgColor;

    switch (_order.status) {
      case OrderStatus.paymentConfirmed:
        bgColor = Colors.white;
        content = ElevatedButton(
          onPressed: () => _showMarkAsReadyModal(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            S.of(context).markAsReady,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        break;
      case OrderStatus.preparing:
        bgColor = Colors.blue.shade50;
        content = Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).waitingDriver,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
        break;
      case OrderStatus.shipped:
        bgColor = Colors.teal.shade50;
        content = Row(
          children: [
            const Icon(Icons.local_shipping_outlined, color: Colors.teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).orderOnWay,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
        break;
      case OrderStatus.delivered:
        bgColor = Colors.green.shade50;
        content = Text(
          S.of(context).payoutScheduled('45,000', '25 May'),
          style: TextStyle(
            fontSize: 13,
            color: Colors.green.shade700,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case OrderStatus.cancelled:
        bgColor = Colors.red.shade50;
        content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).cancellationReason,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              _order.cancellationReason ?? 'No reason provided',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(child: content),
    );
  }

  void _showMarkAsReadyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MarkAsReadyModal(
        order: _order,
        onConfirm: () {
          setState(() {
            _order = _order.copyWith(
              status: OrderStatus.preparing,
              timeline: {
                ..._order.timeline,
                OrderStatus.preparing: DateTime.now(),
              },
            );
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MarkAsReadyModal extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onConfirm;

  const _MarkAsReadyModal({required this.order, required this.onConfirm});

  @override
  State<_MarkAsReadyModal> createState() => _MarkAsReadyModalState();
}

class _MarkAsReadyModalState extends State<_MarkAsReadyModal> {
  final Set<String> _checkedItems = {};

  Widget _buildLowStockWarning(CartItem item) {
    final int currentStock = 12;
    final int remaining = currentStock - (item.qty);

    if (remaining < 10) {
      return Container(
        margin: const EdgeInsets.only(top: 4, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                S
                    .of(context)
                    .lowStockWarning(item.productName ?? '', remaining),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).confirmReadyItems,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...widget.order.items.map(
            (item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: _checkedItems.contains(item.id.toString()),
                  onChanged: (v) {
                    setState(() {
                      if (v!) {
                        _checkedItems.add(item.id.toString());
                      } else {
                        _checkedItems.remove(item.id.toString());
                      }
                    });
                  },
                  title: Text(
                    item.productName ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text('Qty: ${item.qty}'),
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                _buildLowStockWarning(item),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkedItems.length == widget.order.items.length
                ? widget.onConfirm
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Confirm Order Ready',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
