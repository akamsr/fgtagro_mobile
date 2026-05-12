import 'package:fgtagro_mobile/models/category.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool active;
  final Map<String, dynamic> style;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    this.active = false,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.secondaryColor
                    : const Color(0xFFF5F3F8),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                style['icon'] as IconData,
                size: 22,
                color: active ? Colors.white : AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.secondaryColor : Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
