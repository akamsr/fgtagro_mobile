import 'package:auto_route/auto_route.dart';

class BusinessGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // final bool tokenExpired = Functionhelper.isTokenExpired(
    //   locator<StorageServices>().accesToken ?? "",
    // );
  }
}

class BusinessPaidGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next();
  }
}
