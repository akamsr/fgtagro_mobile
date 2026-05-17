import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/order.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system_state.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Buyer filter: 0=All, 1=Active, 2=Completed, 3=Cancelled
  int _buyerFilter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<OrderModel> _filteredBuyerOrders(List<OrderModel> orders) {
    var list = orders.where((o) {
      if (_searchQuery.isNotEmpty) {
        return o.orderNumber
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();

    switch (_buyerFilter) {
      case 1:
        list = list.where((o) => o.status.isActive).toList();
        break;
      case 2:
        list = list.where((o) => o.status.isCompleted || o.status.isRefundable).toList();
        break;
      case 3:
        list = list.where((o) => o.status.isCancelled).toList();
        break;
    }

    // Active orders float to the top
    list.sort((a, b) {
      if (a.status.isActive && !b.status.isActive) return -1;
      if (!a.status.isActive && b.status.isActive) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSystemCubit, OrderSystemState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F7FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Order Management',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildRoleTab(
                        context,
                        role: OrderSystemRole.buyer,
                        label: 'Buyer',
                        icon: Icons.shopping_bag_outlined,
                        isActive: state.currentRole == OrderSystemRole.buyer,
                      ),
                      const SizedBox(width: 8),
                      _buildRoleTab(
                        context,
                        role: OrderSystemRole.seller,
                        label: 'Seller',
                        icon: Icons.storefront_outlined,
                        isActive: state.currentRole == OrderSystemRole.seller,
                      ),
                      const SizedBox(width: 8),
                      _buildRoleTab(
                        context,
                        role: OrderSystemRole.driver,
                        label: 'Driver',
                        icon: Icons.local_shipping_outlined,
                        isActive: state.currentRole == OrderSystemRole.driver,
                      ),
                      const SizedBox(width: 8),
                      _buildRoleTab(
                        context,
                        role: OrderSystemRole.storeManager,
                        label: 'Store',
                        icon: Icons.warehouse_outlined,
                        isActive:
                            state.currentRole == OrderSystemRole.storeManager,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: _buildCurrentRoleView(state),
        );
      },
    );
  }


  Widget _buildRoleTab(
    BuildContext context, {
    required OrderSystemRole role,
    required String label,
    required IconData icon,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<OrderSystemCubit>().setRole(role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRoleView(OrderSystemState state) {
    switch (state.currentRole) {
      case OrderSystemRole.buyer:
        return _buildBuyerDashboard(state);
      case OrderSystemRole.seller:
        return _buildSellerDashboard(state);
      case OrderSystemRole.driver:
        return _buildDriverDashboard(state);
      case OrderSystemRole.storeManager:
        return _buildStoreManagerDashboard(state);
    }
  }

  // ==========================================
  // BUYER DASHBOARD
  // ==========================================
  Widget _buildBuyerDashboard(OrderSystemState state) {
    final filteredOrders = _filteredBuyerOrders(state.orders);

    return Column(
      children: [
        _buildSearchBar(),
        _buildBuyerFilterChips(),
        Expanded(
          child: filteredOrders.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView.builder(

                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildBuyerOrderCard(order);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by order number...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBuyerFilterChips() {
    final labels = ['All', 'Active', 'Completed', 'Cancelled'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = _buyerFilter == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _buyerFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade200,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Aucune commande trouvée',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Faites des achats pour voir vos commandes s\'afficher ici.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerOrderCard(OrderModel order) {
    final statusColor = _getStatusColor(order.status);
    final statusLabel = _getStatusLabel(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              color: statusColor.withOpacity(0.06),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                      Row(
                        children: [
                          Icon(
                            order.deliveryMethod == 'HOME_DELIVERY'
                                ? Icons.local_shipping_outlined
                                : Icons.storefront_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.deliveryMethod == 'HOME_DELIVERY'
                                ? 'À domicile'
                                : 'Retrait boutique',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${order.totalAmount.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<OrderSystemCubit>().selectOrder(order.id);
                          CustomNavigate.push(
                            const BuyerOrderDetailRoute(),
                          );
                        },
                        child: const Text(
                          'Détails',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SELLER DASHBOARD
  // ==========================================
  Widget _buildSellerDashboard(OrderSystemState state) {
    final sellerOrders = state.orders.where((o) =>
        o.status == OrderStatus.paymentConfirmed ||
        o.status == OrderStatus.preparing).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Commandes à Traiter (SLA 48h)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        Expanded(
          child: sellerOrders.isEmpty
              ? _buildEmptyRoleState('Aucune commande en attente de préparation.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sellerOrders.length,
                  itemBuilder: (context, index) {
                    final order = sellerOrders[index];
                    return _buildSellerOrderCard(order);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSellerOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.red, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '36h restantes',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '• ${item.quantity}x ${item.name} (${item.unit})',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal: ${order.subtotalAmount.toStringAsFixed(0)} FCFA',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (order.status == OrderStatus.paymentConfirmed)
                ElevatedButton(
                  onPressed: () {
                    _showSellerReadyDialog(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirmer le colis'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'En cours de préparation',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSellerReadyDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Confirmer la préparation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veuillez cocher tous les articles pour confirmer qu\'ils sont emballés et prêts.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ...order.items.map((item) => CheckboxListTile(
                        value: true,
                        onChanged: (v) {},
                        title: Text(item.name),
                        subtitle: Text('${item.quantity} ${item.unit}'),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primaryColor,
                      )),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<OrderSystemCubit>().updateOrderStatus(
                          order.id,
                          OrderStatus.preparing,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Commande marquée prête ! Attente d\'un chauffeur.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================
  // DRIVER DASHBOARD
  // ==========================================
  Widget _buildDriverDashboard(OrderSystemState state) {
    final driverOrders = state.orders.where((o) =>
        o.deliveryMethod == 'HOME_DELIVERY' &&
        (o.status == OrderStatus.preparing ||
            o.status == OrderStatus.shipped)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Livraisons Assignées',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        Expanded(
          child: driverOrders.isEmpty
              ? _buildEmptyRoleState('Aucune livraison active assignée.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: driverOrders.length,
                  itemBuilder: (context, index) {
                    final order = driverOrders[index];
                    return _buildDriverOrderCard(order);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDriverOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == OrderStatus.preparing
                      ? Colors.orange.shade50
                      : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status == OrderStatus.preparing
                      ? 'À récupérer'
                      : 'En cours de livraison',
                  style: TextStyle(
                    color: order.status == OrderStatus.preparing
                        ? Colors.orange.shade700
                        : Colors.purple.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Adresse: ${order.shippingAddress ?? "Non spécifiée"}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          if (order.status == OrderStatus.preparing)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderSystemCubit>().updateOrderStatus(
                        order.id,
                        OrderStatus.shipped,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Package picked up ✓ En route!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Confirm Pickup (Scan QR)',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.map_outlined, color: Colors.white, size: 16),
                        label: const Text('Track Live',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          context.read<OrderSystemCubit>().selectOrder(order.id);
                          context.read<OrderSystemCubit>().startTrackingSimulation();
                          CustomNavigate.push(const RealTimeTrackingRoute());
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 16),
                        label: const Text('Confirm Delivery',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          context.read<OrderSystemCubit>().selectOrder(order.id);
                          CustomNavigate.push(
                              DriverDeliveryConfirmRoute(orderId: order.id));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
  // STORE MANAGER DASHBOARD
  // ==========================================
  Widget _buildStoreManagerDashboard(OrderSystemState state) {
    final storeOrders = state.orders.where((o) =>
        o.deliveryMethod == 'STORE_PICKUP' &&
        (o.status == OrderStatus.paymentConfirmed ||
            o.status == OrderStatus.preparing)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Retraits Boutique en Attente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        Expanded(
          child: storeOrders.isEmpty
              ? _buildEmptyRoleState('Aucun retrait boutique en attente.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: storeOrders.length,
                  itemBuilder: (context, index) {
                    final order = storeOrders[index];
                    return _buildStoreManagerOrderCard(order);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStoreManagerOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () {
        context.read<OrderSystemCubit>().selectOrder(order.id);
        CustomNavigate.push(StoreManagerOrderDetailRoute(orderId: order.id));
      },
      child: Container(

      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == OrderStatus.paymentConfirmed
                      ? Colors.teal.shade50
                      : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status == OrderStatus.paymentConfirmed
                      ? 'À préparer'
                      : 'Prêt pour retrait',
                  style: TextStyle(
                    color: order.status == OrderStatus.paymentConfirmed
                        ? Colors.teal.shade700
                        : Colors.purple.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '• ${item.quantity}x ${item.name}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              )),
          const Divider(height: 24),
          if (order.status == OrderStatus.paymentConfirmed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderSystemCubit>().updateOrderStatus(
                        order.id,
                        OrderStatus.preparing,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Colis emballé et marqué disponible pour retrait !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Confirmer l\'emballage'),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderSystemCubit>().updateOrderStatus(
                        order.id,
                        OrderStatus.delivered,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Commande récupérée par le client !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Manage Pickup',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    ),  // end GestureDetector child Container
    );  // end GestureDetector
  }

  Widget _buildEmptyRoleState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // UTIL METHODS
  // ==========================================
  Color _getStatusColor(OrderStatus status) {
    if (status.isActive) {
      switch (status) {
        case OrderStatus.paymentPending:
        case OrderStatus.pending:
          return Colors.orange;
        case OrderStatus.paymentConfirmed:
          return Colors.teal;
        case OrderStatus.preparing:
          return Colors.blue;
        case OrderStatus.driverAssigned:
        case OrderStatus.pickedUp:
        case OrderStatus.outForDelivery:
        case OrderStatus.shipped:
          return Colors.purple;
        case OrderStatus.readyForPickup:
          return Colors.indigo;
        case OrderStatus.delivered:
          return Colors.green;
        default:
          return Colors.grey;
      }
    }
    if (status.isCompleted || status.isRefundable) return Colors.green;
    if (status.isCancelled) return Colors.red;
    return Colors.grey.shade500;
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.paymentPending:
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.paymentConfirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.driverAssigned:
        return 'Driver Assigned';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.outForDelivery:
      case OrderStatus.shipped:
        return 'Out for Delivery';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.refundRequested:
        return 'Dispute Open';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.refundRejected:
        return 'Dispute Rejected';
      case OrderStatus.deliveryFailed:
        return 'Delivery Failed';
      case OrderStatus.pickupExpired:
        return 'Pickup Expired';
      case OrderStatus.cancelledByBuyer:
      case OrderStatus.cancelledAuto:
      case OrderStatus.cancelledByAdmin:
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.paymentFailed:
        return 'Payment Failed';
      case OrderStatus.expired:
        return 'Expired';
    }
  }
}


