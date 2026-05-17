import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CheckoutStepper extends StatelessWidget {
  final int activeStep;
  const CheckoutStepper({super.key, required this.activeStep});

  static const _steps = ['Livraison', 'Expédition', 'Paiement'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            final lineStep = i ~/ 2;
            final done = lineStep < activeStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 2,
                color: done ? AppColors.primaryColor : Colors.grey.shade200,
              ),
            );
          }
          final step = i ~/ 2;
          final isDone = step < activeStep;
          final isActive = step == activeStep;
          return _StepDot(
            label: _steps[step],
            number: step + 1,
            isDone: isDone,
            isActive: isActive,
          );
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String label;
  final int number;
  final bool isDone;
  final bool isActive;

  const _StepDot({
    required this.label,
    required this.number,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive
                ? AppColors.primaryColor
                : Colors.grey.shade200,
            border: isActive
                ? Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 4,
                  )
                : null,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primaryColor : Colors.grey,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
