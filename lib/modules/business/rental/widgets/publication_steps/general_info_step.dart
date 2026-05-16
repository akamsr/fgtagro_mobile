import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:flutter/material.dart';

class GeneralInfoStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const GeneralInfoStep({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final equipmentTypes = [
      'Tractor', 'Harvester', 'Plough', 'Irrigation Pump', 
      'Sprayer', 'Seeder', 'Generator', 'Other'
    ];
    final conditions = ['Excellent', 'Good', 'Fair', 'Needs minor repairs'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'General Information',
          subtitle: 'Tell us the basics about your equipment to help tenants find exactly what they need.',
        ),
        CustomDropdown<String>(
          label: 'Equipment Type',
          required: true,
          value: data['type'],
          items: equipmentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (v) => onUpdate('type', v),
        ),
        CustomTextField(
          label: 'Brand',
          required: true,
          hint: 'e.g. John Deere',
          controller: TextEditingController(text: data['brand'])..selection = TextSelection.collapsed(offset: (data['brand'] ?? '').length),
          onChanged: (v) => onUpdate('brand', v),
        ),
        CustomTextField(
          label: 'Model',
          required: true,
          hint: 'e.g. 5075E',
          controller: TextEditingController(text: data['model'])..selection = TextSelection.collapsed(offset: (data['model'] ?? '').length),
          onChanged: (v) => onUpdate('model', v),
        ),
        _buildYearPicker(context),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Engine Power',
                hint: 'e.g. 75',
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: data['power']?.toString() ?? '')..selection = TextSelection.collapsed(offset: (data['power']?.toString() ?? '').length),
                onChanged: (v) => onUpdate('power', double.tryParse(v)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: CustomDropdown<String>(
                label: 'Unit',
                value: data['powerUnit'] ?? 'HP',
                items: ['HP', 'kW'].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (v) => onUpdate('powerUnit', v),
              ),
            ),
          ],
        ),
        CustomDropdown<String>(
          label: 'Condition',
          required: true,
          value: data['condition'],
          items: conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => onUpdate('condition', v),
        ),
      ],
    );
  }

  Widget _buildYearPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(label: 'Year of Manufacture'),
        InkWell(
          onTap: () async {
            final year = await showDialog<int>(
              context: context,
              builder: (context) => _YearPickerDialog(
                selectedYear: data['year'] ?? DateTime.now().year,
              ),
            );
            if (year != null) onUpdate('year', year);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['year']?.toString() ?? 'Select Year',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: data['year'] != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _YearPickerDialog extends StatelessWidget {
  final int selectedYear;

  const _YearPickerDialog({required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Year'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
          ),
          itemCount: DateTime.now().year - 1980 + 1,
          itemBuilder: (context, index) {
            final year = DateTime.now().year - index;
            return InkWell(
              onTap: () => Navigator.of(context).pop(year),
              child: Center(
                child: Text(
                  year.toString(),
                  style: TextStyle(
                    fontWeight: year == selectedYear ? FontWeight.bold : FontWeight.normal,
                    color: year == selectedYear ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
