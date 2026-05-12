import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ProductHeroAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ProductHeroAction({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: AppColors.secondaryColor),
      ),
    );
  }
}
