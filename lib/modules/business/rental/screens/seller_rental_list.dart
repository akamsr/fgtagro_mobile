import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/modules/business/rental/cubit/rental.cubit.dart';
import 'package:fgtagro_mobile/modules/business/rental/cubit/rental.state.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/bookings_tab.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/equipment_tab.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/history_tab.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SellerRentalListScreen extends StatefulWidget {
  const SellerRentalListScreen({super.key});

  @override
  State<SellerRentalListScreen> createState() => _SellerRentalListScreenState();
}

class _SellerRentalListScreenState extends State<SellerRentalListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['EQUIPMENT', 'BOOKINGS', 'HISTORY'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    context.read<RentalCubit>().fetchAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentalCubit, RentalState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bgCanvas,
          appBar: AppBar(
            title: Text(
              S.of(context).rentalsManagement,
              style: const TextStyle(
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
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: S.of(context).tabEquipment),
                Tab(text: S.of(context).tabBookings),
                Tab(text: S.of(context).tabHistory),
              ],
            ),
          ),
          body: state.genLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    EquipmentTab(equipment: state.equipment),
                    BookingsTab(bookings: state.bookings),
                    HistoryTab(history: state.history),
                  ],
                ),
          floatingActionButton: _tabController.index == 0
              ? FloatingActionButton.extended(
                  onPressed: () =>
                      context.router.push(const EquipmentPublicationRoute()),
                  backgroundColor: AppColors.primaryColor,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    S.of(context).listEquipment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(String tabLabel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '${S.of(context).noItemsFound(tabLabel)}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
