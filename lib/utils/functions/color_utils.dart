import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ColorUtils {
  static String getHexCodeFromTitle(String selectedColorTitle) {
    final List<String> colorValues = [
      'White',
      'Red',
      'Grey',
      'Black',
      'Gold',
      'Blue',
      'Green',
      'Orange',
      'Yellow',
      'Beige',
      'Purple',
      'Brown',
      'Pink',
    ];

    final Map<String, String> colorHexCodes = {
      'White': '#FFFFFF',
      'Red': '#FF0000',
      'Grey': '#808080',
      'Black': '#000000',
      'Gold': '#FFD700',
      'Blue': '#0000FF',
      'Green': '#008000',
      'Orange': '#FFA500',
      'Yellow': '#FFFF00',
      'Beige': '#F5F5DC',
      'Purple': '#800080',
      'Brown': '#A52A2A',
      'Pink': '#FFC0CB',
    };

    final selectedColor = colorValues.firstWhere(
      (color) => color.toLowerCase() == selectedColorTitle.toLowerCase(),
      orElse: () => 'FFFFFF',
    );

    return colorHexCodes[selectedColor] ?? '';
  }

  Color transactionColor(String status) {
    if (status == 'PAYMENT_HOLDING' || status == 'ACCEPTED AND HOLDING') {
      return AppColors.warningFg;
    } else if (status == 'PAYMENT_PROCESSING' ||
        status == 'PENDING' ||
        status == 'pending') {
      return AppColors.warningFg;
    } else if (status == 'PAYMENT_RELEASED' ||
        status == 'ACCEPTED AND COMPLETED') {
      return AppColors.successFg;
    } else if (status == 'SUCCESSFUL' || status == 'complete') {
      return AppColors.successFg;
    } else if (status == 'FAILED') {
      return AppColors.dangerFg;
    } else if (status == 'DECLINED') {
      return AppColors.dangerFg;
    } else if (status == 'proceed') {
      return AppColors.infoFg;
    } else {
      return AppColors.primaryColor;
    }
  }
}
