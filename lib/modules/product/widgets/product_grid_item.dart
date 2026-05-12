import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/product.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(ProductDetailRoute(id: product.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: product.photos.isNotEmpty
                      ? DecorationImage(image: NetworkImage(product.photos[0]), fit: BoxFit.cover)
                      : null,
                  color: Colors.grey.shade100,
                ),
                child: product.photos.isEmpty
                    ? const Center(child: Icon(Icons.inventory_2, color: Colors.grey, size: 40))
                    : null,
              ),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.unitPrice} FCFA',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primaryColor),
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
