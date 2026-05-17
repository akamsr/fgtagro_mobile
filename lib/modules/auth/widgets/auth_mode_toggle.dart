import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class AuthModeToggle extends StatelessWidget {
  final String currentMode;
  final Function(String) onModeChanged;

  const AuthModeToggle({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onModeChanged('phone'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentMode == 'phone'
                  ? AppColors.secondaryColor
                  : Colors.grey[200],
              foregroundColor: currentMode == 'phone'
                  ? Colors.white
                  : Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Téléphone'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onModeChanged('email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentMode == 'email'
                  ? AppColors.secondaryColor
                  : Colors.grey[200],
              foregroundColor: currentMode == 'email'
                  ? Colors.white
                  : Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Email'),
          ),
        ),
      ],
    );
  }
}
