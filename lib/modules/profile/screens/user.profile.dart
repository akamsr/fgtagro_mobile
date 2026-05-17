import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:fgtagro_mobile/modules/auth/cubit/auth.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.cubit.dart';
import 'package:fgtagro_mobile/modules/business/cubit/business.state.dart';
import 'package:fgtagro_mobile/modules/profile/widgets/profile_menu_item.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fgtagro_mobile/modules/profile/screens/seller_profile_view.dart';
import 'package:fgtagro_mobile/modules/profile/screens/buyer_profile_view.dart';
import 'package:fgtagro_mobile/utils/functions/navigate.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, businessState) {
        final isSeller = businessState.appMode == AppMode.seller;

        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.user == null) {
              CustomNavigate.replaceAll([const LoginRoute()]);
            }
          },
          builder: (context, state) {
            final user = state.user;

            return Scaffold(
              backgroundColor: const Color(0xFFFBF8FD),
              appBar: AppBar(
                title: Text(
                  isSeller
                      ? S.of(context).businessDashboard
                      : S.of(context).myProfile,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
              body: isSeller
                  ? SellerProfileView(user: user)
                  : BuyerProfileView(user: user),
            );
          },
        );
      },
    );
  }
}
