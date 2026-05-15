import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Initial
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),

    // Auth
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: ResetPasswordOtpRoute.page),
    AutoRoute(page: VerifyEmailRoute.page),

     // Standalone Screens
     AutoRoute(page: ProductListRoute.page),
     AutoRoute(page: ProductDetailRoute.page),
     AutoRoute(page: CartRoute.page),
     AutoRoute(page: CheckoutRoute.page),
     AutoRoute(page: ConversationDetailRoute.page),
    AutoRoute(page: SellerDashboardRoute.page),
    AutoRoute(page: CreateStoreRoute.page),
    AutoRoute(page: SellerOnboardRoute.page),
     AutoRoute(page: NotificationsRoute.page),
     AutoRoute(page: LanguageSettingsRoute.page),

    // Main navigation home page
    AutoRoute(
      page: HomeDashBoardRoute.page,
      children: [
        AutoRoute(page: DashboardHomeRoute.page, initial: true),
        AutoRoute(page: CategoriesRoute.page),
        AutoRoute(page: ConversationListRoute.page),
        AutoRoute(page: OrdersRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
  ];
}
