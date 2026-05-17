import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load local cart synchronously
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FD),
      appBar: AppBar(
        title: const Text(
          'Mon Panier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => CustomNavigate.back(),
            child: const Text(
              'Continuer',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = state.cart;

          if (state.genLoading && cart == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cart == null || cart.items.isEmpty) {
            return _EmptyCartState();
          }

          // Group items by businessId (seller)
          final Map<int, List<CartItem>> grouped = {};
          for (final item in cart.items) {
            grouped.putIfAbsent(item.businessId, () => []).add(item);
          }

          return Column(
            children: [
              if (state.remainingSeconds > 0)
                _TimerBar(
                  seconds: state.remainingSeconds,
                  progress: state.timerProgress,
                ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final businessId = grouped.keys.elementAt(index);
                    return _SellerGroup(items: grouped[businessId]!);
                  },
                ),
              ),

              _CartFooter(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final int seconds;
  final double progress;
  const _TimerBar({required this.seconds, required this.progress});

  @override
  Widget build(BuildContext context) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    final label =
        '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';

    Color color = Colors.green;
    if (seconds <= 120)
      color = Colors.red;
    else if (seconds <= 300)
      color = Colors.orange;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    'Réservé pour $label',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                'Expire bientôt',
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Seller group
// ─────────────────────────────────────────────────────────────────────────────

class _SellerGroup extends StatelessWidget {
  final List<CartItem> items;
  const _SellerGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    final first = items.first;
    final subtotal = items.fold<double>(0, (s, i) => s + i.finalPrice * i.qty);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        first.sellerName ?? 'Vendeur #${first.businessId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        first.sellerCity ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF2F1EF)),

          // Items
          ...items.map((item) => _CartItemRow(item: item)),

          const Divider(height: 1, color: Color(0xFFF2F1EF)),

          // Subtotal + delivery estimate
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Livraison estimée:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Text(
                      '~2 500 FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sous-total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${subtotal.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cart item row
// ─────────────────────────────────────────────────────────────────────────────

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child: item.productPhoto != null
                  ? Image.network(item.productPhoto!, fit: BoxFit.cover)
                  : const Icon(Icons.inventory_2, color: Colors.grey, size: 26),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Produit #${item.productId}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.finalPrice.toStringAsFixed(0)} FCFA / ${item.unit ?? 'unité'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QtyBtn(
                      icon: Icons.remove,
                      onTap: () => context.read<CartCubit>().updateQuantity(
                        item.id,
                        item.qty - 1,
                      ),
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.qty}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _QtyBtn(
                      icon: Icons.add,
                      onTap: item.qty >= item.availableStock
                          ? null
                          : () => context.read<CartCubit>().updateQuantity(
                              item.id,
                              item.qty + 1,
                            ),
                      disabled: item.qty >= item.availableStock,
                    ),
                    const Spacer(),
                    Text(
                      '${(item.finalPrice * item.qty).toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _confirmDelete(context),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                if (item.qty >= item.availableStock && item.availableStock > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Plus que ${item.availableStock} en stock',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final lineTotal = item.finalPrice * item.qty;
    if (lineTotal > 100000) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Retirer cet article ?'),
          content: Text(
            '${item.productName ?? 'Cet article'} — ${lineTotal.toStringAsFixed(0)} FCFA sera retiré de votre panier.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartCubit>().removeFromCart(item.id);
                Navigator.pop(ctx);
              },
              child: const Text('Retirer', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      context.read<CartCubit>().removeFromCart(item.id);
    }
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _QtyBtn({required this.icon, this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: disabled ? Colors.grey.shade200 : AppColors.borderDefault,
          ),
          color: disabled ? Colors.grey.shade50 : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 16,
          color: disabled ? Colors.grey.shade400 : AppColors.secondaryColor,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cart footer
// ─────────────────────────────────────────────────────────────────────────────

class _CartFooter extends StatelessWidget {
  final dynamic cart;
  const _CartFooter({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total général',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  '${cart.grandTotal.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => CustomNavigate.push(const CheckoutRoute()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PASSER LA COMMANDE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${cart.grandTotal.toStringAsFixed(0)} F',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCartState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Votre panier est vide',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Parcourez notre catalogue et ajoutez\nles produits que vous aimez.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => CustomNavigate.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 0,
            ),
            child: const Text(
              'Parcourir les produits',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
