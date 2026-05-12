import 'dart:developer';

import 'package:fgtagro_mobile/modules/dashboard/cubit/home.cubit.dart';
import 'package:fgtagro_mobile/utils/theme/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/custome_comsumer.dart';
import 'package:flutter/material.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Image.asset(
                'assets/images/network_error.png',
                height: 300.h,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 50.h),
              Text(
                S.current.noConnection,
                style: AppStyles.normal.copyWith(fontSize: 40.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                S.current.weAreUnableToConnectToOurServers,
                style: AppStyles.normal.copyWith(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),
              // BlueButton(
              //   text: S.current.tryAgain,
              //   width: 250.h,
              //   color: AppColors.primaryColor,
              //   onTap: onTap ?? () {},
              // ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
      ),
    );
  }
}

class UnExpectedError extends StatelessWidget {
  const UnExpectedError({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Image.asset(
                'assets/images/network_error.png',
                height: 300.h,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 50.h),
              Text(
                S.current.unExpectedErrorHome,
                style: AppStyles.normal.copyWith(fontSize: 40.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                S.current.anUnExpectedErrorOcurredRefresh,
                style: AppStyles.normal.copyWith(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),
              // BlueButton(
              //   text: S.current.tryAgain,
              //   width: 250.h,
              //   color: AppColors.primaryColor,
              //   onTap: onTap ?? () {},
              // ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionError extends StatefulWidget {
  const PermissionError({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<PermissionError> createState() => _PermissionErrorState();
}

class _PermissionErrorState extends State<PermissionError> {
  @override
  Widget build(BuildContext context) {
    return CustomBlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return FutureBuilder(
          future: cubit.hasPermission(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const HomeShimmerScreen();
            // }
            final granted = snapshot.data ?? false;
            log(granted.toString(), name: 'PERMISSION');
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Icon(granted ? Icons.check : Icons.info_outline, size: 80),
                    SizedBox(height: 50.h),
                    Text(
                      granted
                          ? S.current.permissionGranted
                          : S.current.permissionError,
                      style: AppStyles.normal.copyWith(fontSize: 40.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      granted
                          ? S.current.clickTheRefreshButton
                          : S.current.locationPermissionNeeded,
                      style: AppStyles.normal.copyWith(fontSize: 20.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.h),
                    // BlueButton(
                    //   text: granted
                    //       ? S.current.refreshPage
                    //       : S.current.grantPermission,
                    //   width: 250.h,
                    //   color: granted ? AppColors.infoFg : AppColors.primaryColor,
                    //   onTap: widget.onTap ?? () {},
                    // ),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
