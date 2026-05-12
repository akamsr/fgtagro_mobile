import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double width;
  final Map<String, dynamic> categoryStyle;

  const ProductCard({
    super.key,
    required this.product,
    required this.width,
    required this.categoryStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(ProductDetailRoute(id: product.id)),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: categoryStyle['bg'] as Color? ?? const Color(0xFFF5F3F8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: product.photos.isNotEmpty ? DecorationImage(image: NetworkImage(product.photos[0]), fit: BoxFit.cover) : null,
              ),
              alignment: Alignment.center,
              child: product.photos.isEmpty
                  ? Icon(categoryStyle['icon'] as IconData? ?? Icons.inventory_2, size: 52, color: Colors.black12)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondaryColor, height: 1.4),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 11, color: AppColors.primaryColor),
                      const SizedBox(width: 3),
                      const Text('4.5 (12)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.unitPrice} FCFA', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.secondaryColor)),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
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
}
