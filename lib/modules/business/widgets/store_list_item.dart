import 'package:fgtagro_mobile/models/seller.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class StoreListItem extends StatelessWidget {
  final StoreModel store;

  const StoreListItem({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront,
              size: 22,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${store.city}${store.district != null ? ', ${store.district}' : ''} · ${store.code}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: store.status == 'active'
                  ? const Color(0xFFE6FFF0)
                  : const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              store.status == 'active' ? 'Active' : 'Fermée',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: store.status == 'active'
                    ? const Color(0xFF10b981)
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
