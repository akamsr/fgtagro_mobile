import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

// import '../../../../../utils/app_colors.dart';

class AppStyles {
  static TextStyle appbar = TextStyle(
    fontFamily: 'Acme',
    fontSize: 20.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w900,
  );

  static TextStyle header = TextStyle(
    fontFamily: 'Acme',
    fontSize: 22.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w900,
  );
  static TextStyle normal = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 18.sp,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle sectionHeader = TextStyle(
    fontFamily: 'AbrilFatFace',
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor.withValues(alpha: 0.5),
  );

  static TextStyle sectionHeader2 = TextStyle(
    fontSize: 15.sp,
    // fontFamily: FontFamily.poppins,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    // height: 0.07,
  );
  static TextStyle cardText = const TextStyle(
    fontFamily: 'AbrilFatFace',
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static TextStyle cardTitle = const TextStyle(
    fontFamily: 'AbrilFatFace',
    fontSize: 14,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );
  static TextStyle cardSbtitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPlaceholder,
  );
  static TextStyle hint = TextStyle(
    fontFamily: 'Acme',
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPlaceholder,
  );

  static TextStyle hint2 = const TextStyle(
    color: Color(0xFFA5A5A5),
    fontSize: 14,
    fontFamily: 'Actor',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static TextStyle bottomNav = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 11.sp,
    color: AppColors.textPlaceholder,
  );
  // membership page styles
  static TextStyle membershipHead = TextStyle(
    fontFamily: 'Acme',
    fontSize: 18.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w900,
  );
  static TextStyle membershipName = TextStyle(
    fontFamily: 'Acme',
    fontSize: 18.sp,
    color: AppColors.primaryColor,
  );
  static TextStyle membershipBody = TextStyle(
    fontFamily: 'Acme',
    fontSize: 11.sp,
    color: AppColors.textPlaceholder,
  );
  static TextStyle membershipPrice = TextStyle(
    fontFamily: 'Acme',
    fontSize: 22.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle membershipPriceThrough = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 12.sp,
    color: AppColors.textPlaceholder,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle membershipUnderLine = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 11.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w900,
    decoration: TextDecoration.underline,
  );

  static TextStyle button = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.sp,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle smallBold = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textboldSecondary = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 14.sp,
    color: AppColors.navy,
    fontWeight: FontWeight.bold,
  );

  static TextStyle regularHead = TextStyle(
    fontFamily: 'Acme',
    fontSize: 18.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mainHead = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 25.sp,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle regularBody = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 18.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle smallBody = TextStyle(
    fontFamily: 'Gilroy',
    fontSize: 16.sp,
    color: AppColors.textPrimary,
  );

  static final splashName = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w900,
    fontSize: 65.sp,
    color: Colors.white,
  );

  static final priceText = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w800,
    fontSize: 30.sp,
    color: AppColors.primaryColor,
  );

  static final caption = TextStyle(
    fontFamily: "Acme",
    fontWeight: FontWeight.w800,
    fontSize: 25.sp,
    color: Colors.white,
  );

  static final tabText = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static final splashName2 = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w900,
    fontSize: 65.sp,
    color: AppColors.primaryColor,
  );

  static final normTextWhite = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    color: Colors.white,
  );
  static final normTextBlack = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    color: AppColors.textPrimary,
  );

  static final pageTittle = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w700,
    fontSize: 45.sp,
    color: Colors.white,
  );

  static final pageCaption = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    color: AppColors.textPrimary,
  );

  static final secondTitle = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.textPrimary,
  );

  static final secondTitleDark = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.textPrimary,
  );
  static final secondTitleWhite = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.textPrimary,
  );

  static final thirdTitle = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 18.sp,
    color: AppColors.textPrimary,
  );

  static final secondmuted = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
    color: AppColors.textSecondary,
  );

  static final inputTextName = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    color: AppColors.primaryColor,
  );

  static final saveTextStles = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    color: AppColors.textPrimary,
  );

  static final inputTextName2 = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 17.sp,
    color: AppColors.primaryColor,
  );

  static final loginTextName3 = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 17.sp,
    color: AppColors.primaryColor,
  );

  static final onboardName1 = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w900,
    fontSize: 50.sp,
    color: Colors.white,
  );

  static final onboardName2 = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w300,
    fontSize: 28.sp,
    color: Colors.white,
  );

  static final customerServiceHead = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: Colors.white,
  );

  static final customerServiceInputField = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w700,
    fontSize: 13.sp,
    color: AppColors.primaryColor,
  );

  static final customerServiceFirstText = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 15.5.sp,
    color: AppColors.primaryColor,
  );

  static final splashSlogan = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w300,
    fontSize: 17.sp,
    color: Colors.white,
  );
  static const _semiBold = FontWeight.w600;

  /// Button label text style.
  static const commonButtonLabel = TextStyle(
    fontSize: 12,
    fontWeight: _semiBold,
    color: Colors.white,
  );
  static InputDecoration inputfield1(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(30.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(30.0),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Colors.white),
      hintText: label,
      fillColor: Colors.transparent,
    );
  }

  static const colorizeColors = [
    Colors.green,
    Color.fromARGB(255, 5, 45, 78),
    Colors.yellow,
    Colors.red,
  ];

  static final colorizeTextStyle = TextStyle(
    fontSize: 15.sp,
    fontFamily: 'Horizon',
  );

  static final inputTextName2Alt = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    color: Colors.white,
  );

  static final smallessText = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    color: AppColors.textPrimary,
  );

  static final appText = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    color: AppColors.textPrimary,
  );

  static final textNameBold = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: Colors.white,
  );
  static final textNameBoldB = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 35.sp,
    color: AppColors.textPrimary,
  );

  static final textNameMutedB = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 17.sp,
    color: AppColors.textSecondary,
  );

  static final textNameMuted = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    color: AppColors.textSecondary,
  );
  static final textNameBoldA = TextStyle(
    fontFamily: "Lexend",
    fontWeight: FontWeight.w700,
    fontSize: 22.sp,
    color: AppColors.textPrimary,
  );

  static final Prata = TextStyle(
    fontFamily: "Prata",
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.primaryColor,
  );

  static final buzmeHeader = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'Praise',
    color: AppColors.primaryColor,
  );

  static final GeffryFont = TextStyle(
    fontFamily: "Geffry",
    fontSize: 14.sp,
    color: AppColors.textPrimary,
  );

  static InputDecoration inputDecoration({
    double? borderRaduis,
    String? hintText,
    Widget? icon,
    String? errorText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 1,
              shadowColor: Colors.grey,
              child: Icon(prefixIcon, size: 20, color: AppColors.navy600),
            )
          : null,
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.navy600),
        borderRadius: BorderRadius.circular(borderRaduis!),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.successFg),
        borderRadius: BorderRadius.circular(borderRaduis),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.navy600),
        borderRadius: BorderRadius.circular(borderRaduis),
      ),
      hintText: hintText,
      suffixIcon: icon,
      errorText: errorText,
    );
  }

  static InputDecoration inputDecorationPlaintext({
    double? borderRaduis,
    String? hintText,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                shadowColor: AppColors.primaryColor,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(prefixIcon, size: 18, color: AppColors.navy600),
                ),
              ),
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, size: 25, color: AppColors.navy600)
          : null,
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(borderRaduis!),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(borderRaduis),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(borderRaduis),
      ),
      hintText: hintText,
      errorText: errorText,
    );
  }

  static InputDecoration inputDecorationPlaintextAlt({
    double? borderRaduis,
    String? hintText,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppStyles.hint,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, size: 25, color: AppColors.navy600)
          : null,
      // contentPadding: const EdgeInsets.only(top: 0, left: 15),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(borderRaduis ?? 0),
      ),
      errorText: errorText,
    );
  }

  static const InputDecoration inputDecorationX = InputDecoration(
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  );

  static InputDecoration inputfield2(String label) {
    return InputDecoration(
      suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Colors.white),
      hintText: label,
      fillColor: Colors.transparent,
    );
  }

  static InputDecoration inputfield3(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Colors.white),
      hintText: label,
      fillColor: Colors.transparent,
    );
  }

  static InputDecoration inputfield4(
    String label,
    VoidCallback onPressSuffix,
    IconData suffixIcon,
  ) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(top: 3, left: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(30.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(30.0),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Colors.white),
      hintText: label,
      fillColor: Colors.transparent,
      suffixIcon: IconButton(
        onPressed: onPressSuffix,
        icon: Icon(suffixIcon, color: Colors.white),
      ),
    );
  }
}
