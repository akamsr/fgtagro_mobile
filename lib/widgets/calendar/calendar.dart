import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.onDayChanged,
    required this.projectDates,
  });

  final Function(DateRangePickerSelectionChangedArgs) onDayChanged;
  final List<DateTime> projectDates;

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      backgroundColor: Colors.white,
      onViewChanged: (dateRangePickerViewChangedArgs) {},
      onSelectionChanged: onDayChanged,
      selectionColor: AppColors.infoFg,
      selectionMode: DateRangePickerSelectionMode.single,
      allowViewNavigation: true,
      showNavigationArrow: true,
      initialSelectedDates: projectDates,
      enablePastDates: true,
      todayHighlightColor: AppColors.infoFg,
      monthCellStyle: DateRangePickerMonthCellStyle(
        disabledDatesTextStyle: const TextStyle(
          color: AppColors.textPlaceholder,
          fontFamily: 'Acme',
        ),
        textStyle: TextStyle(
          color: AppColors.primaryColor,
          fontFamily: 'Acme',
          fontSize: 13.sp,
        ),
      ),
      rangeTextStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontFamily: 'Acme',
      ),
      selectionTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Acme',
      ),
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: Colors.white,
        textStyle: TextStyle(
          color: AppColors.primaryColor,
          fontFamily: 'Acme',
          fontSize: 20.sp,
        ),
      ),
      // monthViewSettings: DateRangePickerMonthViewSettings(),
    );
  }
}
