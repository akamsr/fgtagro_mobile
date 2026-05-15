import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              image: item.productPhoto != null
                  ? DecorationImage(
                      image: NetworkImage(item.productPhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.productPhoto == null
                ? const Icon(Icons.inventory_2, color: Colors.grey, size: 24)
                : null,
          ),
          const SizedBox(width: 12),
          // Details
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
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.finalPrice.toStringAsFixed(0)} FCFA / ${item.unit ?? "unité"}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                // Controls
                Row(
                  children: [
                    _QuantitySelector(item: item),
                    const Spacer(),
                    Text(
                      '${(item.finalPrice * item.qty).toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => _handleDelete(context, item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

  void _handleDelete(BuildContext context, CartItem item) {
    final lineTotal = item.finalPrice * item.qty;
    if (lineTotal > 100000) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Retirer cet article ?'),
          content: Text('${item.productName} — ${lineTotal.toStringAsFixed(0)} FCFA sera retiré de votre panier.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartCubit>().removeFromCart(item.id);
                Navigator.pop(context);
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

class _QuantitySelector extends StatelessWidget {
  final CartItem item;

  const _QuantitySelector({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMax = item.qty >= item.availableStock;

    return Row(
      children: [
        _CircleButton(
          icon: Icons.remove,
          onTap: () => context.read<CartCubit>().updateQuantity(item.id, item.qty - 1),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            '${item.qty}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _CircleButton(
          icon: Icons.add,
          onTap: isMax ? null : () => context.read<CartCubit>().updateQuantity(item.id, item.qty + 1),
          disabled: isMax,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _CircleButton({required this.icon, this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: disabled ? Colors.grey.shade200 : Colors.grey.shade300),
          color: disabled ? Colors.grey.shade100 : Colors.transparent,
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
