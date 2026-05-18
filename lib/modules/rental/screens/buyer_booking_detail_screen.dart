import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';

@RoutePage()
class BuyerBookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const BuyerBookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: const Text('Booking Details', style: TextStyle(color: AppColors.secondaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBanner(),
            const SizedBox(height: 24),
            _buildEquipmentInfo(),
            const SizedBox(height: 24),
            _buildRentalPeriod(),
            const SizedBox(height: 24),
            _buildFinancialSummary(),
            const SizedBox(height: 24),
            if (booking.status == 'ACTIVE') _buildActiveActions(context),
            if (booking.status == 'CONFIRMED') _buildConfirmedActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    Color color;
    String title;
    String description;

    switch (booking.status) {
      case 'PENDING':
        color = Colors.amber;
        title = 'Waiting for owner to accept';
        description = 'The owner has 24 hours to respond. Your payment is held securely in escrow.';
        break;
      case 'CONFIRMED':
        color = Colors.blue;
        title = 'Booking confirmed ✓';
        description = 'Your rental starts on ${DateFormat('dd MMM yyyy').format(booking.startDate)}.';
        break;
      case 'ACTIVE':
        color = Colors.green;
        title = 'Rental in progress';
        final days = booking.endDate.difference(DateTime.now()).inDays;
        description = '$days days remaining · Ends ${DateFormat('dd MMM yyyy').format(booking.endDate)}';
        break;
      case 'COMPLETED':
        color = Colors.grey;
        title = 'Rental completed';
        description = 'Equipment returned successfully.';
        break;
      default:
        color = Colors.red;
        title = booking.status;
        description = 'This booking has been ${booking.status.toLowerCase()}.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEquipmentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Equipment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${booking.equipment.brand} ${booking.equipment.model}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  const Text('Owner: Jean K.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Ref: ${booking.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRentalPeriod() {
    final dateFormat = DateFormat('dd MMM yyyy');
    final duration = booking.endDate.difference(booking.startDate).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rental Period', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Start Date', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(dateFormat.format(booking.startDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('End Date', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(dateFormat.format(booking.endDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Duration', style: TextStyle(color: Colors.grey)),
                  Text('$duration days', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    final currencyFormat = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Financial Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rental amount', style: TextStyle(color: Colors.grey)),
                  Text(currencyFormat.format(booking.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Security deposit', style: TextStyle(color: Colors.grey)),
                  Text(currencyFormat.format(booking.equipment.securityDeposit), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('Held in escrow', style: TextStyle(fontSize: 12, color: AppColors.primaryColor)),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(currencyFormat.format(booking.totalAmount + booking.equipment.securityDeposit), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryColor)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            context.router.push(ActiveRentalTrackingRoute(booking: booking));
          },
          icon: const Icon(Icons.map, color: Colors.white),
          label: const Text('Track equipment on map', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Text('Request extension', style: TextStyle(color: AppColors.primaryColor)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('Report a problem', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildConfirmedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.phone, color: Colors.white),
          label: const Text('Contact Owner', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('Cancel booking', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
