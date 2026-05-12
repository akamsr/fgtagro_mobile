import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/cart/cubit/cart.cubit.dart';
import 'package:fgtagro_mobile/modules/conversation/cubit/conversation.cubit.dart';
import 'package:fgtagro_mobile/modules/dashboard/cubit/order.cubit.dart';
import 'package:fgtagro_mobile/modules/product/cubit/product.cubit.dart';
import 'package:fgtagro_mobile/modules/seller/cubit/seller.cubit.dart';
import 'package:fgtagro_mobile/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDev});

  final bool isDev;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => ProductCubit()),
            BlocProvider(create: (context) => SellerCubit()),
            BlocProvider(create: (context) => ConversationCubit()),
            BlocProvider(create: (context) => OrderCubit()),
            BlocProvider(create: (context) => CartCubit()),
          ],
          child: MaterialApp.router(
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
          ),
        );
      },
    );
  }
}
