import 'dart:async';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/theme/styles.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/functions/navigate.dart';

class PopUpHelper {
  static Future<dynamic> showPopUp(
    Widget child,
    bool? barrierDimissal, {
    BuildContext? context,
  }) async {
    final currentContext = CustomNavigate.currentContext;
    if (currentContext == null) return;
    
    final isDialogShowing =
        ModalRoute.of(context ?? currentContext)?.isCurrent == false;

    if (isDialogShowing) return;
    return await showGeneralDialog(
      context: context ?? currentContext,
      barrierDismissible: barrierDimissal ?? true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, widget) {
        final curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              content: Padding(
                padding: EdgeInsets.all(10.r),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> showCustomPopUp(Widget child) async {
    final context = CustomNavigate.currentContext;
    if (context == null) return;
    return await showDialog(
      context: context,
      builder: (context) => child,
    );
  }

  static Future<dynamic> showBottomSheet(
    Widget child, {
    double padding = 10,
    bool isMap = false,
    double? height,
  }) async {
    final context = CustomNavigate.currentContext;
    if (context == null) return;
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: height ?? MediaQuery.sizeOf(context).height * 0.5,
            padding: EdgeInsets.all(padding.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: isMap
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.75,
                      child: Column(children: [Expanded(child: child)]),
                    ),
                  )
                : Container(
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        const Tip(),
                        SizedBox(height: 20.h),
                        Expanded(child: child),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class Tip extends StatelessWidget {
  const Tip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}

class AlertComingSoon extends StatelessWidget {
  const AlertComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber),
              SizedBox(width: 5.w),
              Text(
                S.current.featInDev,
                softWrap: true,
                style: AppStyles.normal.copyWith(fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            S.current.comingInOctober2024,
            style: AppStyles.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class AlertGeneric extends StatelessWidget {
  const AlertGeneric({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber),
              SizedBox(width: 5.w),
              Text(
                title,
                softWrap: true,
                style: AppStyles.normal.copyWith(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(body, style: AppStyles.cardTitle),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class InfoButtonWithPopup extends StatelessWidget {
  const InfoButtonWithPopup({
    super.key,
    required this.icon,
    required this.info,
  });

  final IconData icon;
  final String info;

  void _showPopupInfo(BuildContext context, RenderBox button) {
    final buttonPosition = button.localToGlobal(Offset.zero);
    // final buttonSize = button.size;

    late OverlayEntry overlay; // Declare overlay variable first

    overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full screen GestureDetector to close popup when tapping outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlay.remove(), // Now overlay is in scope
              child: Container(color: Colors.transparent),
            ),
          ),
          // Popup content
          Positioned(
            right: 12.h,
            top: buttonPosition.dy,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minWidth: 100,
                ),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(info)],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlay);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4.h,
      top: 4.h,
      child: GestureDetector(
        onTap: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          _showPopupInfo(context, button);
        },
        child: Icon(icon, color: AppColors.textPlaceholder),
      ),
    );
  }
}
