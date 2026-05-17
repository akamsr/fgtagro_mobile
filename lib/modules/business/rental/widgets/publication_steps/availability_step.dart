import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AvailabilityStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const AvailabilityStep({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Availability',
          subtitle:
              'Set when your equipment is available for rent and define your booking rules.',
        ),
        const FormLabel(label: 'Availability Calendar'),
        const Text(
          'Tap dates to mark them as unavailable (grey). Green dates are available.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        _buildCalendar(),
        const SizedBox(height: 32),
        CustomDropdown<String>(
          label: 'Minimum Notice Period',
          value: data['noticePeriod'] ?? '24h',
          items: [
            'Same day',
            '24h',
            '48h',
            '72h',
            '1 week',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => onUpdate('noticePeriod', v),
        ),
        CustomDropdown<String>(
          label: 'Minimum Rental Duration',
          value: data['minDuration'] ?? '1 day',
          items: [
            '1 hour',
            'half-day',
            '1 day',
            '3 days',
            '1 week',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => onUpdate('minDuration', v),
        ),
        CustomDropdown<String>(
          label: 'Maximum Rental Duration',
          value: data['maxDuration'] ?? 'No limit',
          items: [
            '1 day',
            '3 days',
            '1 week',
            '1 month',
            'No limit',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => onUpdate('maxDuration', v),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.multiple,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          onUpdate('unavailableDates', args.value);
        },
        initialSelectedDates:
            (data['unavailableDates'] as List<DateTime>? ?? []),
        headerStyle: const DateRangePickerHeaderStyle(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        monthViewSettings: const DateRangePickerMonthViewSettings(
          firstDayOfWeek: 1,
          dayFormat: 'EEE',
        ),
        selectionColor: Colors.grey.shade400,
        todayHighlightColor: AppColors.primaryColor,
      ),
    );
  }
}
