import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.state.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/custome_comsumer.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/theme/styles.dart';
import 'package:fgtagro_mobile/widgets/icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.headBody,
    this.top,
    this.barHeight = 120,
    required this.removeShadow,
    required this.iconName,
    this.appTitleStyle,
    this.onGoback,
    this.trailing,
  }) : super(key: key);

  final String? title;
  final Widget? headBody;
  final double? barHeight;
  final double? top;
  final bool removeShadow;
  final String iconName;
  final TextStyle? appTitleStyle;
  final Function()? onGoback;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: top ?? 20.h,
          left: 20.w,
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width -
                (headBody == null ? 80.w : 40.w),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10), // 20
                child:
                    headBody ??
                    Row(
                      children: [
                        // CustomBackButton(
                        //   removeShadow: removeShadow,
                        //   iconName: iconName,
                        //   onTap: onGoback,
                        // ),
                        Expanded(
                          child: Center(
                            child: Text(
                              title ?? '',
                              style: appTitleStyle?.copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ),

                        // if (trailing != null) const Spacer(),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    final path = Path();

    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.50,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomAppBarMain extends StatefulWidget {
  const CustomAppBarMain({Key? key, required this.title, this.page, this.child})
    : super(key: key);
  final String? title;
  final String? page;
  final Widget? child;

  @override
  State<CustomAppBarMain> createState() => _CustomAppBarMainState();
}

class _CustomAppBarMainState extends State<CustomAppBarMain>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<CartCubit, CartState>(
      builder: (context, state) {
        return SizedBox(
          height: 300.h,
          child: Stack(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 210.h, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20.h,
                left: 20.w,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/buzme_logo_home.svg',
                                    height: 30.h,
                                  ),
                                  SizedBox(height: 14.h),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                // InkWell(
                                //   onTap: () => {
                                //     CustomNavigate.push(const CategoryRoute()),
                                //   },
                                //   child: BuzmeIcon(BuzmeIcons.menu, size: 22.w),
                                // ),
                                Expanded(child: SizedBox(width: 25.w)),

                                // Stack(
                                //   children: [
                                //     InkWell(
                                //       onTap: () => locator<AppRouter>().push(
                                //         const NotificationsRoute(),
                                //       ),
                                //       child: BuzmeIcon(
                                //         BuzmeIcons.notification,
                                //         size: 22.w,
                                //       ),
                                //     ),
                                //     // if (context
                                //     //     .read<NotificationCubit>()
                                //     //     .notifications
                                //     //     .isNotEmpty)
                                //     //   Positioned(
                                //     //       right: 0,
                                //     //       top: -5,
                                //     //       child: Container(
                                //     //         padding:
                                //     //             const EdgeInsets.all(2),
                                //     //         decoration: const BoxDecoration(
                                //     //             shape: BoxShape.circle,
                                //     //             color:
                                //     //                 AppColors.primaryColor),
                                //     //         child: Text(
                                //     //           context
                                //     //               .read<NotificationCubit>()
                                //     //               .notifications
                                //     //               .length
                                //     //               .toString(),
                                //     //           style: const TextStyle(
                                //     //               fontSize: 13,
                                //     //               color:
                                //     //                   AppColors.successFg),
                                //     //         ),
                                //     //       ))
                                //   ],
                                // ),
                                SizedBox(width: 15.w),

                                // if (locator<StorageServices>().businessId !=
                                //     null)

                                // CustomBlocConsumer<
                                //   FavouriteCubit,
                                //   FavouriteState
                                // >(
                                //   listener: (context, state) {},
                                //   builder: (context, state) {
                                //     return Stack(
                                //       children: [
                                //         InkWell(
                                //           onTap: () => CustomNavigate.push(
                                //             const FavouritesRoute(),
                                //           ),
                                //           child: BuzmeIcon(
                                //             BuzmeIcons.heart,
                                //             size: 22.w,
                                //           ),
                                //         ),
                                //         if (context
                                //             .read<FavouriteCubit>()
                                //             .favourites
                                //             .isNotEmpty)
                                //           Positioned(
                                //             right: 0,
                                //             top: -5,
                                //             child: Container(
                                //               padding: const EdgeInsets.all(2),
                                //               decoration: const BoxDecoration(
                                //                 shape: BoxShape.circle,
                                //                 color: AppColors.primaryColor,
                                //               ),
                                //               child: Text(
                                //                 context
                                //                     .read<FavouriteCubit>()
                                //                     .favourites
                                //                     .length
                                //                     .toString(),
                                //                 style: const TextStyle(
                                //                   fontSize: 13,
                                //                   color: AppColors.successFg,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //       ],
                                //     );
                                //   },
                                // ),
                                SizedBox(width: 15.w),

                                // Stack(
                                //   children: [
                                //     InkWell(
                                //       child: BuzmeIcon(
                                //         BuzmeIcons.cart,
                                //         size: 22.w,
                                //       ),
                                //       onTap: () => CustomNavigate.push(
                                //         const CartRoute(),
                                //       ),
                                //     ),
                                //     if (context
                                //         .read<CartCubit>()
                                //         .cartItems
                                //         .isNotEmpty)
                                //       Positioned(
                                //         right: 0,
                                //         top: -5,
                                //         child: Container(
                                //           padding: const EdgeInsets.all(2),
                                //           decoration: const BoxDecoration(
                                //             shape: BoxShape.circle,
                                //             color: AppColors.primaryColor,
                                //           ),
                                //           child: Text(
                                //             context
                                //                 .read<CartCubit>()
                                //                 .cartItems
                                //                 .length
                                //                 .toString(),
                                //             style: const TextStyle(
                                //               fontSize: 13,
                                //               color: AppColors.successFg,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //   ],
                                // ),
                                SizedBox(width: 25.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100.h,
                // left: 20.w,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              height: 55.h,
                              padding: EdgeInsets.symmetric(
                                vertical: 5.h,
                                horizontal: 15.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textPlaceholder.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(27.h),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/search.svg',
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 6.w),

                                  // Expanded(
                                  //   child: TextFormField(
                                  //     onTap: () => showModalBottomSheet(
                                  //       isScrollControlled: true,
                                  //       backgroundColor: AppColors.bgCanvas,
                                  //       context: context,
                                  //       shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.vertical(
                                  //           top: Radius.circular(10.0),
                                  //         ),
                                  //       ),
                                  //       builder: (contex) =>
                                  //           const FractionallySizedBox(
                                  //             heightFactor: 0.8,
                                  //             child: CustomBottomSheet(
                                  //               type: BottomSheetType.loading,
                                  //             ),
                                  //           ),
                                  //     ),
                                  //     // enabled: false,
                                  //     decoration: InputDecoration(
                                  //       hintText: S.current.search,
                                  //       hintStyle: AppStyles.hint,
                                  //       focusedBorder: InputBorder.none,
                                  //       enabledBorder: InputBorder.none,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 155.h,
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  width: MediaQuery.of(context).size.width,
                  child: widget.child ?? const Center(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppBarBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 0);

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    final path = Path();

    path.moveTo(0, rect.height * 0.70);
    path.quadraticBezierTo(
      rect.width / 2,
      rect.height,
      rect.width,
      rect.height * 0.70,
    );
    path.lineTo(rect.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}

class AppBarBack extends StatelessWidget {
  const AppBarBack({super.key, this.onTap, required this.title});
  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: MediaQuery.of(context).size.width - 40.w,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w), // 20
          child: Row(
            children: [
              SizedBox(width: 10.w),
              InkWell(
                onTap: onTap,
                child: BuzmeIcon(BuzmeIcons.left_arrow, size: 22.sp),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: AppStyles.appbar.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
