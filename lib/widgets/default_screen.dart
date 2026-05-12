import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_app_bar.dart';

class DefaultScreen extends StatelessWidget {
  final String? appBarTitle;
  final Widget? appBarLeadingAction;
  final Widget? appBarTrailingAction;
  final List<Widget>? children;
  final Widget? child;
  final bool centerAppBarTitle;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;

  final Widget? appBarBody;
  final double? appBarTop;
  final Widget? appBar;
  final double? appBarHeight;
  final bool hideNavBar;

  final bool extraPadding;
  final double? extraPaddingValue;

  final bool safeAreaLeft;
  final bool safeAreaTop;
  final bool safeAreaRight;
  final bool safeAreaBottom;
  final bool isProfile;
  final bool extraIcons;
  final bool scrollAuto;
  final double paddingHorizontal;
  final bool isBasicInfo;
  final VoidCallback? onTap;
  final String imgUrl;
  final ScrollController? onScroll;
  final bool removeShadowBackButton;
  final String backButtonName;
  final TextStyle? appTitleStyle;
  final Color? backgroundColor2;

  final Function()? goBack;

  final CrossAxisAlignment crossAxisAlignment;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;

  DefaultScreen({
    Key? key,
    this.children,
    this.appBarTitle,
    this.goBack,
    this.floatingActionButton,
    this.extraPaddingValue,
    this.removeShadowBackButton = false,
    this.backButtonName = 'left_arrow',
    this.appBarTop,
    this.appTitleStyle = const TextStyle(
      color: Color(0xFF001D3D),
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 0,
    ),
    this.appBarBody,
    this.appBarHeight,
    this.appBarLeadingAction,
    this.appBarTrailingAction,
    this.centerAppBarTitle = true,
    this.backgroundColor = AppColors.bgCanvas,
    this.bottomNavigationBar,
    this.safeAreaLeft = true,
    this.safeAreaTop = true,
    this.safeAreaRight = true,
    this.safeAreaBottom = true,
    this.isProfile = false,
    this.extraIcons = false,
    this.hideNavBar = false,
    this.scrollAuto = true,
    this.paddingHorizontal = 15,
    this.isBasicInfo = false,
    this.extraPadding = true,
    this.backgroundColor2 = const Color(0XFFF5F8FF),
    this.onTap,
    this.imgUrl =
        'https://media.istockphoto.com/id/1196083861/vector/simple-man-head-icon-set.jpg?s=612x612&w=0&k=20&c=a8fwdX6UKUVCOedN_p0pPszu8B4f6sjarDmUGHngvdM=',
    this.child = const Center(),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.appBar,
    this.onScroll,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  bool _showAppBar() {
    return appBarTitle != null ||
        appBarLeadingAction != null ||
        appBarBody != null ||
        appBar != null ||
        appBarTrailingAction != null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: Container(
            color: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SafeArea(
                    left: safeAreaLeft,
                    top: safeAreaTop,
                    right: safeAreaRight,
                    bottom: safeAreaBottom,
                    child: Column(
                      crossAxisAlignment: crossAxisAlignment,
                      children: [
                        Expanded(
                          child: Stack(
                            // alignment: Alignment.topCenter,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontal.w,
                                ),
                                child: scrollAuto
                                    ? SingleChildScrollView(
                                        controller: onScroll,
                                        // keyboardDismissBehavior:
                                        //     ScrollViewKeyboardDismissBehavior
                                        //         .onDrag,
                                        child: Column(
                                          crossAxisAlignment:
                                              crossAxisAlignment,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!isProfile && _showAppBar())
                                              SizedBox(height: 120.h),
                                            ...children!,
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          top: extraPadding
                                              ? extraPaddingValue ?? 95.h
                                              : 0,
                                        ),
                                        child: child,
                                      ),
                              ),
                              if (_showAppBar())
                                (appBar ??
                                    (CustomAppBar(
                                      onGoback: goBack,
                                      appTitleStyle: appTitleStyle,
                                      removeShadow: removeShadowBackButton,
                                      iconName: backButtonName,
                                      top: appBarTop,
                                      barHeight: appBarHeight,
                                      title: appBarTitle,
                                      trailing: appBarTrailingAction,
                                      headBody: appBarBody,
                                    ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (bottomNavigationBar != null) ...[
                    isKeyboardVisible
                        ? SizedBox(height: 400.h)
                        : bottomNavigationBar!,
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
