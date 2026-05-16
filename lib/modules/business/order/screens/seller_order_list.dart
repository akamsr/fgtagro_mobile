import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.cubit.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class SellerOrderListScreen extends StatefulWidget {
  const SellerOrderListScreen({super.key});

  @override
  State<SellerOrderListScreen> createState() => _SellerOrderListScreenState();
}

class _SellerOrderListScreenState extends State<SellerOrderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<OrderStatus?> _statusTabs = [
    null, // ALL
    OrderStatus.pending,
    OrderStatus.preparing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text(
          S.of(context).myOrders,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.secondaryColor),
            onPressed: () => context.read<OrderCubit>().fetchOrders(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      context.read<OrderCubit>().setSearchQuery(v),
                  decoration: InputDecoration(
                    hintText: S.of(context).searchOrdersHint,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: _statusTabs.map((status) {
                  return Tab(text: _getStatusLabel(status));
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.genLoading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: _statusTabs.map((status) {
              final filteredOrders = context
                  .read<OrderCubit>()
                  .getFilteredOrders(status);

              if (filteredOrders.isEmpty) {
                return _buildEmptyState(_getStatusLabel(status));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _OrderCard(order: filteredOrders[index]),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _getStatusLabel(OrderStatus? status) {
    if (status == null) return S.of(context).statusAll;
    switch (status) {
      case OrderStatus.pending:
        return S.of(context).statusPending;
      case OrderStatus.preparing:
        return S.of(context).statusPreparing;
      case OrderStatus.shipped:
        return S.of(context).statusShipped;
      case OrderStatus.delivered:
        return S.of(context).statusDelivered;
      case OrderStatus.cancelled:
        return S.of(context).statusCancelled;
      case OrderStatus.paymentConfirmed:
        return S.of(context).statusPaymentConfirmed;
    }
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).noOrdersWithStatus(status),
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'FCFA',
      decimalDigits: 0,
    );
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt);

    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.orderNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (order.status == OrderStatus.pending)
                  _buildSLATimer(context),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _DeliveryBadge(method: order.deliveryMethod),
                const Spacer(),
                Text(
                  S.of(context).itemsCount(order.items.length),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormatter.format(order.totalAmount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToDetails(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: AppColors.primaryTint.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).viewDetails,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSLATimer(BuildContext context) {
    // 48 hours SLA
    final deadline = order.createdAt.add(const Duration(hours: 48));
    final remaining = deadline.difference(DateTime.now());

    if (remaining.isNegative) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.red, size: 12),
            SizedBox(width: 4),
            Text(
              'SLA Expired',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final isUrgent = remaining.inHours < 24;
    final color = isUrgent ? Colors.red : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            '${remaining.inHours}h ${remaining.inMinutes % 60}m left',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    context.pushRoute(SellerOrderDetailRoute(order: order));
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = S.of(context).statusPending;
        break;
      case OrderStatus.preparing:
        color = Colors.blue;
        label = S.of(context).statusPreparing;
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        label = S.of(context).statusShipped;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        label = S.of(context).statusDelivered;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        label = S.of(context).statusCancelled;
        break;
      case OrderStatus.paymentConfirmed:
        color = Colors.teal;
        label = S.of(context).statusPaymentConfirmed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DeliveryBadge extends StatelessWidget {
  final String method;

  const _DeliveryBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final bool isHome = method == 'HOME_DELIVERY';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHome ? Icons.delivery_dining : Icons.store,
            size: 14,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            isHome ? S.of(context).deliveryHome : S.of(context).deliveryStore,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
