import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';

void showToast(
  String message, {
  Color? color = AppColors.primaryColor,
  Color? bgColor,
}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16.sp,
    backgroundColor: bgColor,
    timeInSecForIosWeb: 2,
    textColor: color ?? AppColors.primaryColor,
    gravity: ToastGravity.TOP,
  );
}
