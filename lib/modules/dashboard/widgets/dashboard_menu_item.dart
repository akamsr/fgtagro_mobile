import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class DashboardMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool divider;
  final VoidCallback onTap;
  final Color? iconBgColor;
  final Color? iconColor;
  final Color? textColor;

  const DashboardMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.divider = false,
    required this.onTap,
    this.iconBgColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: divider
              ? const Border(
                  top: BorderSide(color: Color.fromRGBO(197, 198, 208, 0.5), width: 0.5),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color.fromRGBO(235, 105, 9, 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: iconColor ?? AppColors.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.secondaryColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
