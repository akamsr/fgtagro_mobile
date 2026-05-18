import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/buyer_rental.cubit.dart';
import '../widgets/buyer_browse_tab.dart';
import '../widgets/buyer_my_rentals_tab.dart';

@RoutePage()
class RentalMainScreen extends StatefulWidget {
  const RentalMainScreen({super.key});

  @override
  State<RentalMainScreen> createState() => _RentalMainScreenState();
}

class _RentalMainScreenState extends State<RentalMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyerRentalCubit()..fetchInitialData(),
      child: Scaffold(
        backgroundColor: AppColors.bgCanvas,
        appBar: AppBar(
          title: const Text(
            'Rentals',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
            tabs: const [
              Tab(text: 'Browse'),
              Tab(text: 'My Rentals'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            BuyerBrowseTab(),
            BuyerMyRentalsTab(),
          ],
        ),
      ),
    );
  }
}
