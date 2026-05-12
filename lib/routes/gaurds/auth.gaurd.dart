import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/services/auth/auth.services.dart';
import 'package:fgtagro_mobile/utils/functions/helpers.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/widgets/bottom_navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final bool tokenExpired = Functionhelper.isTokenExpired(
      locator<StorageServices>().accesToken ?? "",
    );

    if (locator<StorageServices>().userId != null) {
      if (tokenExpired) {
        unawaited(ApiService().refreshUserToken());
      }
      return resolver.next();
    } else {
      Future.microtask(() async {
        final context = CustomNavigate.currentContext;
        if (context == null) {
          resolver.next(false);
          return;
        }
        await showModalBottomSheet<bool>(
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 20.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            // child: const LoginModal(),
            child: const SizedBox.shrink(),
          ),
        ).then((value) {
          if (value != true) {
            final context = CustomNavigate.currentContext;
            if (context != null) {
              try {
                context.read<BottomNavProvider>().onIndexChange(0);
              } catch (e) {}
            }
          } else {
            resolver.next(true);
          }
        });
      });
    }
  }
}
