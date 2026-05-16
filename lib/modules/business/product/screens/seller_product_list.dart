import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.state.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class SellerProductListScreen extends StatefulWidget {
  const SellerProductListScreen({super.key});

  @override
  State<SellerProductListScreen> createState() => _SellerProductListScreenState();
}

class _SellerProductListScreenState extends State<SellerProductListScreen> {
  String selectedFilter = 'ALL';
  final TextEditingController _searchController = TextEditingController();

  final List<String> filters = [
    'ALL',
    'PUBLISHED',
    'EN_VALIDATION',
    'DRAFT',
    'OUT_OF_STOCK',
    'SUSPENDED',
    'ARCHIVED'
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text(
          S.of(context).myProducts,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => context.router.push(const ProductPublicationRoute()),
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
              label: Text(
                S.of(context).newProduct,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.genLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredProducts = state.products.where((p) {
                  final matchesSearch = p.name.toLowerCase().contains(_searchController.text.toLowerCase());
                  final matchesFilter = selectedFilter == 'ALL' || p.status.toUpperCase() == selectedFilter;
                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _SellerProductCard(product: filteredProducts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).searchYourProducts,
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() {}),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: filters.map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      filter.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => selectedFilter = filter);
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide.none,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            S.of(context).noProductsFound,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _SellerProductCard extends StatelessWidget {
  final ProductModel product;

  const _SellerProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          if (product.status.toUpperCase() == 'REJECTED' || product.status.toUpperCase() == 'CHANGES_REQUIRED')
            _buildAdminFeedback(context),
          Row(
            children: [
              _buildThumbnail(),
              const SizedBox(width: 12),
              Expanded(child: _buildDetails(formatter)),
              _buildActionMenu(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminFeedback(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Text(
                S.of(context).adminFeedback,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'The photos provided are blurry. Please upload clear photos of the NPK label and the back of the bag.',
            style: TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        image: product.photos.isNotEmpty
            ? DecorationImage(image: NetworkImage(product.photos[0]), fit: BoxFit.cover)
            : null,
      ),
      child: product.photos.isEmpty ? const Icon(Icons.image, color: Colors.grey) : null,
    );
  }

  Widget _buildDetails(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          product.category.name,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${formatter.format(product.unitPrice)} / ${product.unitOfSale}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
            _StatusBadge(status: product.status.toUpperCase()),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Stock: ${product.stockQuantity}',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
          onPressed: () => _showContextualMenu(context),
        ),
      ],
    );
  }

  void _showContextualMenu(BuildContext context) {
    final status = product.status.toUpperCase();
    final List<Widget> actions = [];

    switch (status) {
      case 'PUBLISHED':
        actions.addAll([
          _menuItem(context, Icons.edit_outlined, S.of(context).edit),
          _menuItem(context, Icons.inventory_2_outlined, S.of(context).updateStock, onTap: () => _showStockUpdate(context)),
          _menuItem(context, Icons.archive_outlined, S.of(context).archive),
        ]);
        break;
      case 'DRAFT':
        actions.addAll([
          _menuItem(context, Icons.edit_outlined, S.of(context).edit),
          _menuItem(context, Icons.send_outlined, S.of(context).submitForReview),
          _menuItem(context, Icons.delete_outline, S.of(context).delete, color: Colors.red),
        ]);
        break;
      case 'EN_VALIDATION':
        actions.addAll([
          _menuItem(context, Icons.visibility_outlined, S.of(context).view),
          _menuItem(context, Icons.undo_outlined, S.of(context).withdrawSubmission),
        ]);
        break;
      case 'OUT_OF_STOCK':
        actions.addAll([
          _menuItem(context, Icons.inventory_2_outlined, S.of(context).updateStock, onTap: () => _showStockUpdate(context)),
        ]);
        break;
      case 'SUSPENDED':
        actions.addAll([
          _menuItem(context, Icons.info_outline, S.of(context).viewSuspensionReason),
          _menuItem(context, Icons.support_agent_outlined, S.of(context).contactSupport),
        ]);
        break;
      case 'ARCHIVED':
        actions.addAll([
          _menuItem(context, Icons.publish_outlined, S.of(context).republish),
          _menuItem(context, Icons.delete_forever_outlined, S.of(context).deletePermanently, color: Colors.red),
        ]);
        break;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ...actions,
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, {VoidCallback? onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.secondaryColor, size: 22),
      title: Text(label, style: TextStyle(color: color ?? AppColors.secondaryColor, fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }

  void _showStockUpdate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StockUpdateBottomSheet(product: product),
    );
  }
}

class _StockUpdateBottomSheet extends StatefulWidget {
  final ProductModel product;
  const _StockUpdateBottomSheet({required this.product});

  @override
  State<_StockUpdateBottomSheet> createState() => _StockUpdateBottomSheetState();
}

class _StockUpdateBottomSheetState extends State<_StockUpdateBottomSheet> {
  late TextEditingController _mainController;

  @override
  void initState() {
    super.initState();
    _mainController = TextEditingController(text: widget.product.stockQuantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    final bool isGIAManaged = false; // Placeholder for logic

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).updateStock, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.product.name, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          if (!isGIAManaged) ...[
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: S.of(context).newStockQuantity,
                suffixText: widget.product.unitOfSale,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ] else ...[
            // GIA Per-store breakdown mock
            _buildStoreItem('GIA Store Bafoussam', 50),
            _buildStoreItem('GIA Store Douala', 120),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).stockUpdatedSuccessfully)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(S.of(context).update, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreItem(String storeName, int currentStock) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Current: $currentStock', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'New qty',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    final String s = status.toUpperCase();
    switch (s) {
      case 'PUBLISHED': color = Colors.green; break;
      case 'EN_VALIDATION': color = Colors.orange; break;
      case 'DRAFT': color = Colors.grey; break;
      case 'OUT_OF_STOCK': color = Colors.red; break;
      case 'SUSPENDED': color = Colors.red.shade900; break;
      case 'ARCHIVED': color = Colors.grey.shade400; break;
      case 'CHANGES_REQUIRED':
      case 'REJECTED': color = Colors.red; break;
      default: color = Colors.grey;
    }

    String label = s.replaceAll('_', ' ');
    if (s == 'CHANGES_REQUIRED') label = 'Changes Required';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
