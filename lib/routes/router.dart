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
    AutoRoute(page: BuyerOrderDetailRoute.page),
    AutoRoute(page: RealTimeTrackingRoute.page),
    // Seller Management
    AutoRoute(page: SellerDashboardRoute.page),
    AutoRoute(page: SellerProductListRoute.page),
    AutoRoute(page: ProductPublicationRoute.page),
    AutoRoute(page: CreateStoreRoute.page),
    AutoRoute(page: SellerOnboardRoute.page),
    AutoRoute(page: SellerOrderListRoute.page),
    AutoRoute(page: SellerOrderDetailRoute.page),
    AutoRoute(page: SellerRentalListRoute.page),
    AutoRoute(page: EquipmentPublicationRoute.page),

    // Shared & Settings
    AutoRoute(page: NotificationsRoute.page),
    AutoRoute(page: LanguageSettingsRoute.page),
    AutoRoute(page: FavouritesRoute.page),
    AutoRoute(page: PersonalInformationRoute.page),
    AutoRoute(page: MyAddressesRoute.page),
    AutoRoute(page: NotificationPreferencesRoute.page),
    AutoRoute(page: ContactSupportRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),

    // Main navigation home page (Shell)
    AutoRoute(
      page: HomeDashBoardRoute.page,
      children: [
        // Buyer Tabs
        AutoRoute(page: DashboardHomeRoute.page),
        AutoRoute(page: CategoriesRoute.page),
        AutoRoute(page: ConversationListRoute.page),
        AutoRoute(page: OrdersRoute.page),

        // Seller Tabs
        AutoRoute(page: SellerDashboardRoute.page),
        AutoRoute(page: SellerProductListRoute.page),
        AutoRoute(page: SellerOrderListRoute.page),
        AutoRoute(page: SellerRentalListRoute.page),

        // Shared
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
  ];
}
