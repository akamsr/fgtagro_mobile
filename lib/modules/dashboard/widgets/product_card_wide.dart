import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ProductCardWide extends StatelessWidget {
  final ProductModel product;
  final Map<String, dynamic> categoryStyle;

  const ProductCardWide({
    super.key,
    required this.product,
    required this.categoryStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(ProductDetailRoute(id: product.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: categoryStyle['bg'] as Color? ?? const Color(0xFFF5F3F8),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                image: product.photos.isNotEmpty ? DecorationImage(image: NetworkImage(product.photos[0]), fit: BoxFit.cover) : null,
              ),
              alignment: Alignment.center,
              child: product.photos.isEmpty
                  ? Icon(categoryStyle['icon'] as IconData? ?? Icons.inventory_2, size: 56, color: Colors.black12)
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.secondaryColor),
                          ),
                        ),
                        if (product.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(6)),
                            child: const Text('NEW', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 11, color: AppColors.primaryColor),
                        const SizedBox(width: 3),
                        const Text('4.8 (45)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${product.unitPrice} FCFA', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                        const Text('+ Panier', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primaryColor)),
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
  }
}
