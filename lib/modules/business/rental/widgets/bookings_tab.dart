import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/booking_card.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class BookingsTab extends StatelessWidget {
  final List<BookingModel> bookings;

  const BookingsTab({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No active bookings or requests.'));
    }

    final pending = bookings.where((b) => b.status == 'PENDING').toList();
    final active = bookings.where((b) => b.status == 'ACTIVE').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending.isNotEmpty) ...[
          _buildHeader('New Requests', pending.length, Colors.orange),
          const SizedBox(height: 12),
          ...pending.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BookingCard(booking: b),
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (active.isNotEmpty) ...[
          _buildHeader('Active Rentals', active.length, AppColors.primaryColor),
          const SizedBox(height: 12),
          ...active.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BookingCard(booking: b),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(String title, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
