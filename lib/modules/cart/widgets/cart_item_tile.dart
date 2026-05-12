import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/widgets/quantity_button.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produit #${item.productId}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.secondaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.finalPrice.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantityButton(
                      icon: Icons.remove,
                      onTap: () => context.read<CartCubit>().updateQuantity(item.id, item.qty - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.qty}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    QuantityButton(
                      icon: Icons.add,
                      onTap: () => context.read<CartCubit>().updateQuantity(item.id, item.qty + 1),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => context.read<CartCubit>().removeFromCart(item.id),
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
