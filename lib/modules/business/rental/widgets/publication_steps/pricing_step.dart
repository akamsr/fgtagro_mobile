import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PricingStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const PricingStep({super.key, required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Rental Pricing',
          subtitle:
              'Define your rental rates. All rates are in FCFA. The security deposit helps cover potential damages.',
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Hourly Rate',
                hint: 'optional',
                keyboardType: TextInputType.number,
                suffixText: 'FCFA',
                controller:
                    TextEditingController(
                        text: data['hourlyRate']?.toString() ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (data['hourlyRate']?.toString() ?? '').length,
                      ),
                onChanged: (v) => onUpdate('hourlyRate', double.tryParse(v)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Half-Day Rate',
                hint: 'optional',
                keyboardType: TextInputType.number,
                suffixText: 'FCFA',
                controller:
                    TextEditingController(
                        text: data['halfDayRate']?.toString() ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (data['halfDayRate']?.toString() ?? '').length,
                      ),
                onChanged: (v) => onUpdate('halfDayRate', double.tryParse(v)),
              ),
            ),
          ],
        ),
        CustomTextField(
          label: 'Daily Rate',
          required: true,
          hint: '0',
          keyboardType: TextInputType.number,
          suffixText: 'FCFA',
          controller:
              TextEditingController(text: data['dailyRate']?.toString() ?? '')
                ..selection = TextSelection.collapsed(
                  offset: (data['dailyRate']?.toString() ?? '').length,
                ),
          onChanged: (v) {
            final rate = double.tryParse(v) ?? 0;
            onUpdate('dailyRate', rate);
            // Suggest security deposit (20% of 7 days)
            if (data['securityDeposit'] == null ||
                data['securityDeposit'] == 0) {
              onUpdate('securityDeposit', rate * 7 * 0.2);
            }
          },
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Weekly Rate',
                hint: 'optional',
                keyboardType: TextInputType.number,
                suffixText: 'FCFA',
                controller:
                    TextEditingController(
                        text: data['weeklyRate']?.toString() ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (data['weeklyRate']?.toString() ?? '').length,
                      ),
                onChanged: (v) => onUpdate('weeklyRate', double.tryParse(v)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'Monthly Rate',
                hint: 'optional',
                keyboardType: TextInputType.number,
                suffixText: 'FCFA',
                controller:
                    TextEditingController(
                        text: data['monthlyRate']?.toString() ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (data['monthlyRate']?.toString() ?? '').length,
                      ),
                onChanged: (v) => onUpdate('monthlyRate', double.tryParse(v)),
              ),
            ),
          ],
        ),
        const Divider(height: 40),
        CustomTextField(
          label: 'Security Deposit',
          required: true,
          hint: '0',
          keyboardType: TextInputType.number,
          suffixText: 'FCFA',
          controller:
              TextEditingController(
                  text: data['securityDeposit']?.toString() ?? '',
                )
                ..selection = TextSelection.collapsed(
                  offset: (data['securityDeposit']?.toString() ?? '').length,
                ),
          onChanged: (v) => onUpdate('securityDeposit', double.tryParse(v)),
        ),
        Text(
          'Min deposit must be ≥ 20% of (Daily Rate × 7).',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        CustomDropdown<String>(
          label: 'Fuel Policy',
          required: true,
          value: data['fuelPolicy'] ?? 'Full-to-full',
          items: [
            'Full-to-full',
            'Included in price',
            'Tenant pays separately',
          ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (v) => onUpdate('fuelPolicy', v),
        ),
        const SizedBox(height: 12),
        _buildPricingNote(),
      ],
    );
  }

  Widget _buildPricingNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Rates are in FCFA. The security deposit is held in escrow and returned after the rental if no damage is found.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
