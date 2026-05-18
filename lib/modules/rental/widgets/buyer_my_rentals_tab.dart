import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import '../cubit/buyer_rental.cubit.dart';
import '../cubit/buyer_rental.state.dart';
import 'package:fgtagro_mobile/models/booking.dart';

class BuyerMyRentalsTab extends StatefulWidget {
  const BuyerMyRentalsTab({super.key});

  @override
  State<BuyerMyRentalsTab> createState() => _BuyerMyRentalsTabState();
}

class _BuyerMyRentalsTabState extends State<BuyerMyRentalsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Pending', 'Confirmed', 'Active', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryColor,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
        Expanded(
          child: BlocBuilder<BuyerRentalCubit, BuyerRentalState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return TabBarView(
                controller: _tabController,
                children: _tabs.map((tab) {
                  final filteredRentals = context.read<BuyerRentalCubit>().getFilteredRentals(tab);

                  if (filteredRentals.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRentals.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildBookingCard(context, filteredRentals[index]);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No rental bookings yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse equipment and make your first booking.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    final currencyFormat = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');
    final duration = booking.endDate.difference(booking.startDate).inDays;

    Color statusColor;
    String statusText;

    switch (booking.status) {
      case 'PENDING':
        statusColor = Colors.amber;
        statusText = 'Awaiting owner response';
        break;
      case 'CONFIRMED':
        statusColor = Colors.blue;
        statusText = 'Booking confirmed';
        break;
      case 'ACTIVE':
        statusColor = Colors.green;
        statusText = 'Rental in progress';
        break;
      case 'COMPLETED':
        statusColor = Colors.grey;
        statusText = 'Completed';
        break;
      case 'CANCELLED':
      case 'DECLINED':
      case 'EXPIRED':
        statusColor = Colors.red;
        statusText = booking.status == 'DECLINED' ? 'Declined by owner' : 'Cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = booking.status;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: booking.equipment.photoSlots.containsKey('front')
                      ? Image.network(
                          booking.equipment.photoSlots['front']!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.agriculture, color: Colors.grey),
                        )
                      : const Icon(Icons.agriculture, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${booking.equipment.brand} ${booking.equipment.model}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dateFormat.format(booking.startDate)} → ${dateFormat.format(booking.endDate)}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$duration days · ${currencyFormat.format(booking.totalAmount)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  context.router.push(BuyerBookingDetailRoute(booking: booking));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('View details', style: TextStyle(color: AppColors.primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
