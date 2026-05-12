import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter/cupertino.dart';
import '../../../routes/router.dart';

class BottomNavProvider with ChangeNotifier {
  late TabsRouter tabsRouter;

  void init(BuildContext context) {
    tabsRouter = AutoTabsRouter.of(context);
  }

  bool safeArea = false;

  void safeAreaTop() {
    log(locator<AppRouter>().currentUrl.split('/').last);
    switch (locator<AppRouter>().currentUrl.split('/').last) {
      case 'profile-dashboard':
        safeArea = false;
      case 'supermarket-business-route':
        safeArea = false;
      case 'manage-business-route':
        safeArea = false;
      case 'cameroon-brand-product-route':
        safeArea = false;

      default:
        safeArea = true;
    }
    notifyListeners();
  }

  int currentIndex = 0;
  void onIndexChange(int index) {
    if (index == 0) {
      // CustomNavigate.currentContext!
      //     .read<HomeCubit>()
      //     .filter('Shop', 'product', 0);
      // CustomNavigate.currentContext!.read<HomeCubit>().setSelectedType(null);
      // CustomNavigate.currentContext!.read<HomeCubit>().filterDatabase();
    }

    currentIndex = index;
    tabsRouter.setActiveIndex(index);
    notifyListeners();
  }

  bool showNavbar = true;
  void toggleNavbar(bool show) {
    showNavbar = show;
    notifyListeners();
  }

  void silentSHownavbar() {
    showNavbar = true;
  }
}
