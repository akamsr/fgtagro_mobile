import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomNavigate {
  static BuildContext? get currentContext =>
      locator<AppRouter>().navigatorKey.currentContext;

  static Future<dynamic> push(PageRouteInfo<dynamic> route) async {
    currentContext!.read<BottomNavProvider>().silentSHownavbar();
    return await locator<AppRouter>().push(route);
  }

  static Future<dynamic> pushReplace(PageRouteInfo<dynamic> route) async {
    currentContext!.read<BottomNavProvider>().silentSHownavbar();
    return await locator<AppRouter>().replace(route);
  }

  static Future<dynamic> navigate(PageRouteInfo<dynamic> route) async {
    currentContext!.read<BottomNavProvider>().silentSHownavbar();
    return await locator<AppRouter>().push(route);
  }

  static Future<dynamic> navigateAuth(PageRouteInfo<dynamic> route) async {
    return await locator<AppRouter>().replace(route);
  }

  static Future<dynamic> replaceAll(List<PageRouteInfo<dynamic>> routes) async {
    return await locator<AppRouter>().replaceAll(routes);
  }

  static Future<dynamic> replace(PageRouteInfo<dynamic> route) async {
    currentContext!.read<BottomNavProvider>().silentSHownavbar();
    return await locator<AppRouter>().replace(route);
  }

  static void popTillRoute(PageRouteInfo<dynamic> route) {
    locator<AppRouter>().popUntilRouteWithName(route.routeName);
  }

  static Future<dynamic> pop(BuildContext context, {dynamic result}) async {
    return await context.router.maybePop(result);
    // return result;
    // await locator<AppRouter>().pop();
    // await locator<AppRouter>().pop();
    // Navigator.of(currentContext!).pop();
  }

  static void back() {
    // locator<AppRouter>().pop();
    currentContext!.router.maybePop();
  }

  static void popRoot(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<dynamic> pushIndex(PageRouteInfo<dynamic> route, int index) async {
    currentContext!.read<BottomNavProvider>().onIndexChange(index);
    return await locator<AppRouter>().push(route);
  }

  void changeIndex(int index) {
    currentContext!.read<BottomNavProvider>().onIndexChange(index);
  }

  static Future<void> popAndPush(PageRouteInfo<dynamic> route) async {
    await locator<AppRouter>().popAndPush(route);
  }
}
