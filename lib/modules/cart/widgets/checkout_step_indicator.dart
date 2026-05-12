import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int activeStep;

  const CheckoutStepIndicator({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStep(0, 'Livraison', active: activeStep >= 0),
          _buildLine(active: activeStep >= 1),
          _buildStep(1, 'Paiement', active: activeStep >= 1),
          _buildLine(active: activeStep >= 2),
          _buildStep(2, 'Résumé', active: activeStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String label, {bool active = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${step + 1}',
            style: TextStyle(
              color: active ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? AppColors.secondaryColor : Colors.grey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({bool active = false}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: active ? AppColors.primaryColor : Colors.grey.shade200,
      ),
    );
  }
}
