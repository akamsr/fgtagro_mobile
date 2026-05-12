import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/utils/theme/styles.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BottomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = AppColors.primaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    final path = Path();

    path.moveTo(0, 30.h);

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30.h);

    path.lineTo(size.width * 0.32, 30.h);

    path.quadraticBezierTo(size.width / 2, -40.h, size.width * 0.67, 30.h);

    path.lineTo(size.width * 0.35, 30.h);

    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 1.h),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color: AppColors.textPlaceholder.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.w,
                  left: 10.w,
                  right: 10.w,
                  child: const BarItems(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarItems extends StatefulWidget {
  const BarItems({Key? key}) : super(key: key);

  @override
  State<BarItems> createState() => _BarItemsState();
}

class _BarItemsState extends State<BarItems> {
  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BarItem(
              icon: 'home',
              label: "Accueil",
              index: 0,
              setIndex: () => tabsRouter.setActiveIndex(0),
              isActive: tabsRouter.activeIndex == 0,
            ),
            BarItem(
              icon: 'category',
              label: "Catégories",
              index: 1,
              setIndex: () => tabsRouter.setActiveIndex(1),
              isActive: tabsRouter.activeIndex == 1,
            ),
            BarItem(
              icon: 'message',
              label: "Messages",
              index: 2,
              setIndex: () => tabsRouter.setActiveIndex(2),
              isActive: tabsRouter.activeIndex == 2,
            ),
            BarItem(
              icon: 'cart',
              label: "Commandes",
              index: 3,
              setIndex: () => tabsRouter.setActiveIndex(3),
              isActive: tabsRouter.activeIndex == 3,
            ),
            BarItem(
              icon: 'profile',
              label: "Profil",
              index: 4,
              setIndex: () => tabsRouter.setActiveIndex(4),
              isActive: tabsRouter.activeIndex == 4,
            ),
          ],
        ),
      ),
    );
  }
}

class BarItemHover extends StatelessWidget {
  const BarItemHover({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (_, provider, __) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...List.generate(
                5,
                (index) => SizedBox(
                  width: 50.w,
                  child: Center(
                    child: HoverItem(isActive: provider.currentIndex == index),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BarCamera extends StatelessWidget {
  const BarCamera({Key? key, required this.setIndex, required this.isActive})
    : super(key: key);
  final Function() setIndex;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: setIndex,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Column(
          children: [
            Container(
              height: 45.h,
              width: 45.h,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.infoFg,
                borderRadius: BorderRadius.circular(50.h),
              ),
              child: SvgPicture.asset(
                "Assets.icons.buzmeLogoHome.path",
                height: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6.h),
            Center(
              child: Text(
                '',
                softWrap: false,
                overflow: TextOverflow.clip,
                style: AppStyles.bottomNav.copyWith(
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.textPlaceholder,
                  fontFamily: isActive ? 'Acme' : 'Gilroy',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarItem extends StatelessWidget {
  const BarItem({
    Key? key,
    required this.label,
    this.isActive = false,
    required this.icon,
    this.globalKey,
    required this.index,
    required this.setIndex,
  }) : super(key: key);

  final String label;
  final bool isActive;
  final String icon;
  final int index;
  final GlobalKey? globalKey;
  final Function() setIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: globalKey,
      onTap: setIndex,
      child: SizedBox(
        height: 58.w,
        width: 50.w,
        child: Padding(
          padding: EdgeInsets.only(top: 0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (icon == 'deals')
                Image.asset(
                  isActive
                      ? 'assets/images/deals-active.png'
                      : 'assets/images/deals-inactive.png',
                  height: 25.h,
                  width: 25.h,
                ),
              if (icon != 'deals')
                SvgPicture.asset(
                  'assets/icons/$icon.svg',
                  height: 20.h,
                  width: 20.h,
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withValues(alpha: 0.1),
                ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  label,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: AppStyles.bottomNav.copyWith(
                    color: isActive
                        ? AppColors.primaryColor
                        : AppColors.textPlaceholder,
                    fontFamily: isActive ? 'Acme' : 'Gilroy',
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

class HoverItem extends StatelessWidget {
  const HoverItem({Key? key, this.isActive = false}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -5),
                  blurRadius: 10,
                  color: isActive
                      ? AppColors.successFg.withValues(alpha: 0.5)
                      : Colors.transparent,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  color: isActive
                      ? AppColors.successFg.withValues(alpha: 0.1)
                      : Colors.transparent,
                  spreadRadius: 2,
                ),
              ],
              color: isActive
                  ? AppColors.successFg.withValues(alpha: 0.01)
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 5.w,
            width: 30.w,
            child: SizedBox(height: 5.h),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.successFg : Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          height: 5.w,
          width: 30.w,
          child: SizedBox(height: 5.h),
        ),
      ],
    );
  }
}

class BottomBarBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 0);

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    path.moveTo(rect.size.width * 0.9257803, rect.size.height * 0.2075680);
    path.lineTo(rect.size.width * 0.6396676, rect.size.height * 0.2075680);
    path.cubicTo(
      rect.size.width * 0.6202312,
      rect.size.height * 0.2075680,
      rect.size.width * 0.6014191,
      rect.size.height * 0.1808240,
      rect.size.width * 0.5882717,
      rect.size.height * 0.1316830,
    );
    path.cubicTo(
      rect.size.width * 0.5666850,
      rect.size.height * 0.05101150,
      rect.size.width * 0.5348064,
      0,
      rect.size.width * 0.4992688,
      0,
    );
    path.cubicTo(
      rect.size.width * 0.4637312,
      0,
      rect.size.width * 0.4318699,
      rect.size.height * 0.05101150,
      rect.size.width * 0.4102832,
      rect.size.height * 0.1316830,
    );
    path.cubicTo(
      rect.size.width * 0.3971358,
      rect.size.height * 0.1808240,
      rect.size.width * 0.3783410,
      rect.size.height * 0.2075680,
      rect.size.width * 0.3589017,
      rect.size.height * 0.2075680,
    );
    path.lineTo(rect.size.width * 0.07277601, rect.size.height * 0.2075680);
    path.cubicTo(
      rect.size.width * 0.03298526,
      rect.size.height * 0.2075680,
      rect.size.width * 0.0007225434,
      rect.size.height * 0.3181750,
      rect.size.width * 0.0007225434,
      rect.size.height * 0.4545910,
    );
    path.lineTo(rect.size.width * 0.0007225434, rect.size.height * 0.7452540);
    path.cubicTo(
      rect.size.width * 0.0007225434,
      rect.size.height * 0.8817250,
      rect.size.width * 0.03298526,
      rect.size.height * 0.9923320,
      rect.size.width * 0.07279191,
      rect.size.height * 0.9923320,
    );
    path.lineTo(rect.size.width * 0.9257803, rect.size.height * 0.9923320);
    path.cubicTo(
      rect.size.width * 0.9655694,
      rect.size.height * 0.9923320,
      rect.size.width * 0.9978324,
      rect.size.height * 0.8817250,
      rect.size.width * 0.9978324,
      rect.size.height * 0.7452540,
    );
    path.lineTo(rect.size.width * 0.9978324, rect.size.height * 0.4545910);
    path.cubicTo(
      rect.size.width * 0.9978324,
      rect.size.height * 0.3181200,
      rect.size.width * 0.9655694,
      rect.size.height * 0.2075680,
      rect.size.width * 0.9257803,
      rect.size.height * 0.2075680,
    );
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainterBottomNav extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.9257803, size.height * 0.2075680);
    path_0.lineTo(size.width * 0.6396676, size.height * 0.2075680);
    path_0.cubicTo(
      size.width * 0.6202312,
      size.height * 0.2075680,
      size.width * 0.6014191,
      size.height * 0.1808240,
      size.width * 0.5882717,
      size.height * 0.1316830,
    );
    path_0.cubicTo(
      size.width * 0.5666850,
      size.height * 0.05101150,
      size.width * 0.5348064,
      0,
      size.width * 0.4992688,
      0,
    );
    path_0.cubicTo(
      size.width * 0.4637312,
      0,
      size.width * 0.4318699,
      size.height * 0.05101150,
      size.width * 0.4102832,
      size.height * 0.1316830,
    );
    path_0.cubicTo(
      size.width * 0.3971358,
      size.height * 0.1808240,
      size.width * 0.3783410,
      size.height * 0.2075680,
      size.width * 0.3589017,
      size.height * 0.2075680,
    );
    path_0.lineTo(size.width * 0.07277601, size.height * 0.2075680);
    path_0.cubicTo(
      size.width * 0.03298526,
      size.height * 0.2075680,
      size.width * 0.0007225434,
      size.height * 0.3181750,
      size.width * 0.0007225434,
      size.height * 0.4545910,
    );
    path_0.lineTo(size.width * 0.0007225434, size.height * 0.7452540);
    path_0.cubicTo(
      size.width * 0.0007225434,
      size.height * 0.8817250,
      size.width * 0.03298526,
      size.height * 0.9923320,
      size.width * 0.07279191,
      size.height * 0.9923320,
    );
    path_0.lineTo(size.width * 0.9257803, size.height * 0.9923320);
    path_0.cubicTo(
      size.width * 0.9655694,
      size.height * 0.9923320,
      size.width * 0.9978324,
      size.height * 0.8817250,
      size.width * 0.9978324,
      size.height * 0.7452540,
    );
    path_0.lineTo(size.width * 0.9978324, size.height * 0.4545910);
    path_0.cubicTo(
      size.width * 0.9978324,
      size.height * 0.3181200,
      size.width * 0.9655694,
      size.height * 0.2075680,
      size.width * 0.9257803,
      size.height * 0.2075680,
    );
    path_0.close();

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
