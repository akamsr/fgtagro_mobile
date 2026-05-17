import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/conversation/cubit/conversation.cubit.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/notifications/cubit/notification.cubit.dart';
import 'package:fgtagro_mobile/modules/favourites/cubit/favourites.cubit.dart';
import 'package:fgtagro_mobile/modules/orders/cubit/order_system.cubit.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:fgtagro_mobile/widgets/locale/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDev});

  final bool isDev;

  @override
  Widget build(BuildContext context) {
    final appRouter = locator<AppRouter>();
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => ProductCubit()),
            BlocProvider(create: (context) => BusinessCubit()),
            BlocProvider(create: (context) => ConversationCubit()),
            BlocProvider(create: (context) => OrderCubit()),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(create: (context) => NotificationCubit()),
            BlocProvider(create: (context) => FavouritesCubit()),
            BlocProvider(create: (context) => OrderSystemCubit()),
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BottomNavProvider()),
              ChangeNotifierProvider(create: (_) => LocaleProvider()),
            ],
            child: Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return MaterialApp.router(
                  title: 'FGT Agro',
                  debugShowCheckedModeBanner: isDev,
                  theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: 'Gilroy',
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF10b981),
                    ),
                  ),
                  routerConfig: appRouter.config(),
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  locale: localeProvider.locale,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
