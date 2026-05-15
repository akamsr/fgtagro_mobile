import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductHeroAction extends StatelessWidget {
  final dynamic icon; // Can be IconData or String (SVG path)
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
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: icon is String
            ? SvgPicture.asset(
                icon as String,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryColor,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                icon as IconData,
                size: 20,
                color: AppColors.secondaryColor,
              ),
      ),
    );
  }
}
