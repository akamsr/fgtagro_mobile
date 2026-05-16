import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class ConditionsStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const ConditionsStep({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final experienceLevels = [
      'None', 
      'Basic agricultural knowledge', 
      'Certified operator', 
      'Professional licence required'
    ];
    
    final uses = [
      'Ploughing', 'Sowing', 'Harvesting', 
      'Irrigation', 'Transport', 'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Conditions & Restrictions',
          subtitle: 'Define the rules for using your equipment and specify who is allowed to operate it.',
        ),
        CustomDropdown<String>(
          label: 'Experience Level Required',
          required: true,
          value: data['experienceLevel'] ?? 'None',
          items: experienceLevels.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => onUpdate('experienceLevel', v),
        ),
        const FormLabel(label: 'Permitted Uses', required: true),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: uses.map((use) {
            final List<String> currentUses = List<String>.from(data['permittedUses'] ?? []);
            final bool isSelected = currentUses.contains(use);
            return FilterChip(
              label: Text(use),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  currentUses.add(use);
                } else {
                  currentUses.remove(use);
                }
                onUpdate('permittedUses', currentUses);
              },
              selectedColor: AppColors.primaryTint.withOpacity(0.2),
              checkmarkColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? AppColors.primaryColor : Colors.grey.shade300),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        const FormLabel(label: 'Usage Restrictions (Optional)'),
        TextField(
          maxLines: 4,
          onChanged: (v) => onUpdate('restrictions', v),
          controller: TextEditingController(text: data['restrictions'])..selection = TextSelection.collapsed(offset: (data['restrictions'] ?? '').length),
          decoration: InputDecoration(
            hintText: 'e.g. Not permitted on steep slopes above 30%',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
        const SizedBox(height: 32),
        _buildInsuranceToggle(),
      ],
    );
  }

  Widget _buildInsuranceToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (data['tenantInsuranceRequired'] ?? false) ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (data['tenantInsuranceRequired'] ?? false) ? Colors.blue : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tenant Insurance Required',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Tenants must provide proof of insurance before rental.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: data['tenantInsuranceRequired'] ?? false,
            onChanged: (v) => onUpdate('tenantInsuranceRequired', v),
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
