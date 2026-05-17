import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/modules/orders/screens/dispute_screen.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class BuyerOrderDetailScreen extends StatelessWidget {
  const BuyerOrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSystemCubit, OrderSystemState>(
      builder: (context, state) {
        final order = state.orders.firstWhere(
          (o) => o.id == state.selectedOrderId,
          orElse: () => state.orders.first,
        );

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
              'Détails de la commande',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBanner(context, order),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeaderBlock(context, order),
                      const SizedBox(height: 16),
                      _buildItemsBlock(order),
                      const SizedBox(height: 16),
                      _buildDeliveryInfoBlock(context, order),
                      const SizedBox(height: 16),
                      _buildFinancialSummaryBlock(order),
                      const SizedBox(height: 16),
                      _buildTimelineBlock(order),
                      const SizedBox(height: 24),
                      _buildActionButtons(context, order),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // STATUS BANNER
  // ==========================================
  Widget _buildStatusBanner(BuildContext context, OrderModel order) {
    final statusColor = _getStatusColor(order.status);
    final statusLabel = _getStatusBannerLabel(order.status);
    final icon = _getStatusBannerIcon(order.status);

    return Container(
      width: double.infinity,
      color: statusColor.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statut actuel',
                  style: TextStyle(
                    color: statusColor.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor.darken(),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HEADER BLOCK (Copyable)
  // ==========================================
  Widget _buildHeaderBlock(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.orderNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Numéro de commande copié !'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'N° DE COMMANDE',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.copy_outlined, size: 14, color: Colors.grey.shade400),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.paymentMethod ?? 'MOBILE_MONEY',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DATE ET HEURE', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('PAIEMENT', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(
                    order.paymentStatus == 'CONFIRMED' ? 'Payé ✓' : 'En attente',
                    style: TextStyle(
                      color: order.paymentStatus == 'CONFIRMED' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ITEMS LIST BLOCK
  // ==========================================
  Widget _buildItemsBlock(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRODUITS COMMANDÉS',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxShape.rectangle == BoxShape.circle ? BoxFit.cover : BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.quantity}x ${item.unit}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(item.price * item.quantity).toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
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

  // ==========================================
  // DELIVERY INFO BLOCK (QR Code or Tracking)
  // ==========================================
  Widget _buildDeliveryInfoBlock(BuildContext context, OrderModel order) {
    final isHome = order.deliveryMethod == 'HOME_DELIVERY';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHome ? 'INFORMATIONS DE LIVRAISON' : 'INFORMATIONS DE RETRAIT',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (isHome) ...[
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Adresse de livraison', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        order.shippingAddress ?? 'Rond-point Deido, Douala',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (order.driverName != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.person_pin_outlined, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Livreur assigné', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(
                          order.driverName!,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ] else ...[
            Row(
              children: [
                const Icon(Icons.storefront_outlined, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Boutique de retrait', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        order.storeName ?? 'FGT Agro Boutique Douala',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Text(
                        order.storeAddress ?? 'Boulevard de la Liberté, Akwa',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (order.status == OrderStatus.preparing) ...[
              const Divider(height: 24),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'PRÉSENTEZ CE CODE QR AU COMPTOIR',
                      style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=FGT-4KM29XPL',
                        width: 130,
                        height: 130,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Code: FGT-4KM29XPL',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ==========================================
  // FINANCIAL SUMMARY
  // ==========================================
  Widget _buildFinancialSummaryBlock(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RÉSUMÉ FINANCIER',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Sous-total', '${order.subtotalAmount.toStringAsFixed(0)} FCFA'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Frais de livraison',
            order.deliveryFee > 0 ? '${order.deliveryFee.toStringAsFixed(0)} FCFA' : 'Gratuit',
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '${order.totalAmount.toStringAsFixed(0)} FCFA',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Paiement sécurisé par Escrow. Les fonds ne seront libérés au vendeur qu\'après validation.',
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  // ==========================================
  // TIMELINE HISTORIC BLOCK
  // ==========================================
  Widget _buildTimelineBlock(OrderModel order) {
    final timelineList = order.timeline.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HISTORIQUE DE LA COMMANDE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timelineList.length,
            itemBuilder: (context, index) {
              final entry = timelineList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (index != timelineList.length - 1)
                        Container(
                          width: 2,
                          height: 40,
                          color: AppColors.primaryColor.withOpacity(0.2),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusBannerLabel(entry.key),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(entry.value),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        ),
                        const SizedBox(height: 12),
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

  Widget _buildActionButtons(BuildContext context, OrderModel order) {
    final cubit = context.read<OrderSystemCubit>();

    return Column(
      children: [
        // TRACK — when out for delivery
        if (order.status.canTrack)
          _actionBtn(
            label: 'Track my delivery',
            icon: Icons.local_shipping_outlined,
            color: AppColors.primaryColor,
            onTap: () {
              cubit.startTrackingSimulation();
              CustomNavigate.push(const RealTimeTrackingRoute());
            },
          ),

        // CONFIRM RECEIPT — DELIVERED (48h window)
        if (order.status == OrderStatus.delivered) ...[
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Confirm I received my order ✓',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => DeliveryConfirmationSheet(
                  order: order,
                  onConfirm: () {
                    cubit.updateOrderStatus(order.id, OrderStatus.completed);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you! Order completed. Payout to seller scheduled.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onDispute: () {
                    Navigator.pop(context);
                    CustomNavigate.push(DisputeRoute(orderId: order.id));
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Open a dispute',
            icon: Icons.flag_outlined,
            color: Colors.orange,
            isOutlined: true,
            onTap: () => CustomNavigate.push(DisputeRoute(orderId: order.id)),
          ),
        ],

        // COMPLETED — dispute (7 days) + buy again
        if (order.status == OrderStatus.completed) ...[
          _actionBtn(
            label: 'Open a dispute',
            icon: Icons.flag_outlined,
            color: Colors.orange,
            isOutlined: true,
            onTap: () => CustomNavigate.push(DisputeRoute(orderId: order.id)),
          ),
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Buy again',
            icon: Icons.shopping_bag_outlined,
            color: AppColors.primaryColor,
            isOutlined: true,
            onTap: () {},
          ),
        ],

        // CANCEL — eligible statuses only
        if (order.status.canCancel) ...[
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Cancel order',
            icon: Icons.cancel_outlined,
            color: Colors.red,
            isOutlined: true,
            onTap: () {
              if (order.status == OrderStatus.preparing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Your order is already being prepared and cannot be cancelled. Please contact support.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                CustomNavigate.push(OrderCancellationRoute(orderId: order.id));
              }
            },
          ),
        ],

        // REFUND STATUS — cancelled with pending refund
        if (order.status.isCancelled) ...[
          const SizedBox(height: 8),
          _actionBtn(
            label: 'View refund status',
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.blue,
            isOutlined: true,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Contact support',
            icon: Icons.headset_mic_outlined,
            color: Colors.grey.shade600,
            isOutlined: true,
            onTap: () {},
          ),
        ],

        // DELIVERY FAILED
        if (order.status == OrderStatus.deliveryFailed) ...[
          const SizedBox(height: 8),
          _actionBtn(
            label: 'Contact support',
            icon: Icons.headset_mic_outlined,
            color: Colors.grey.shade600,
            isOutlined: true,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _actionBtn(
            label: 'View refund status',
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.blue,
            isOutlined: true,
            onTap: () {},
          ),
        ],

        // DISPUTE IN PROGRESS
        if (order.status.isRefundable) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.pending_outlined, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.status == OrderStatus.refundRequested
                        ? 'Dispute under review. Our team will respond within 72 hours.'
                        : order.status == OrderStatus.refunded
                            ? 'Refund processed ✓'
                            : 'Dispute resolved — refund rejected.',
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontSize: 12,
                      height: 1.4,
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

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: color),
              label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18, color: Colors.white),
              label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
    );
  }

  // ==========================================
  // UTILS
  // ==========================================
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.paymentConfirmed:
        return Colors.teal;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusBannerIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_empty;
      case OrderStatus.paymentConfirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.settings_suggest_outlined;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusBannerLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente de paiement...';
      case OrderStatus.paymentConfirmed:
        return 'Paiement reçu. Vendeur notifié.';
      case OrderStatus.preparing:
        return 'Le vendeur prépare votre colis...';
      case OrderStatus.shipped:
        return 'Colis remis au livreur. En cours...';
      case OrderStatus.delivered:
        return 'Commande livrée !';
      case OrderStatus.cancelled:
        return 'Commande annulée.';
    }
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
