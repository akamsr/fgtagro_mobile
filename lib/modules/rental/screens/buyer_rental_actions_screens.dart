import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/booking.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RentalExtensionRequestScreen extends StatelessWidget {
  final BookingModel booking;
  const RentalExtensionRequestScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Extension', style: TextStyle(color: AppColors.secondaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current end date: 15 Nov 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Container(
              height: 250,
              color: Colors.grey.shade200,
              child: const Center(child: Text('Calendar Placeholder (Extension)')),
            ),
            const SizedBox(height: 24),
            const Text('Extension: 2 additional days', style: TextStyle(fontSize: 16)),
            const Text('Additional cost: 150,000 FCFA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor)),
            const SizedBox(height: 8),
            const Text('Your existing deposit remains held. No additional deposit required.', style: TextStyle(color: Colors.grey)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.router.maybePop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Send extension request', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class TenantJointInspectionScreen extends StatelessWidget {
  final BookingModel booking;
  const TenantJointInspectionScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: const Text('Joint Inspection', style: TextStyle(color: AppColors.secondaryColor)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Review the owner\'s inspection report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildComparisonPhoto('At rental start', Colors.grey.shade300)),
                const SizedBox(width: 12),
                Expanded(child: _buildComparisonPhoto('At return', Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 24),
            const ListTile(
              title: Text('Hour meter reading'),
              trailing: Text('Start: 1200 | Return: 1224 (24 hrs)'),
            ),
            const ListTile(
              title: Text('Fuel level'),
              trailing: Text('Start: Full | Return: Half'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.router.maybePop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('I acknowledge this inspection report', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonPhoto(String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(height: 150, color: color, child: const Center(child: Icon(Icons.camera_alt))),
      ],
    );
  }
}

@RoutePage()
class DepositDisputeScreen extends StatelessWidget {
  final BookingModel booking;
  const DepositDisputeScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contest Damage Claim')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Explain why you are contesting this damage claim', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter your reason...'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text('Upload evidence photos (max 5)'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.router.maybePop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Submit Dispute', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class MutualRatingScreen extends StatelessWidget {
  final BookingModel booking;
  const MutualRatingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate your rental experience')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text('How was your experience with Jean K.?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => const Icon(Icons.star_border, size: 48, color: Colors.amber)),
            ),
            const SizedBox(height: 32),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Share your experience with this equipment and owner...',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.router.maybePop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Submit Rating', style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () => context.router.maybePop(),
              child: const Text('Skip', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class TheftReportScreen extends StatelessWidget {
  final BookingModel booking;
  const TheftReportScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Theft')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: const Text(
                '⚠ Warning: This will immediately alert FGT AGRO and the owner. Only report theft if you are certain.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(value: true, onChanged: (v) {}),
                const Expanded(
                  child: Text('I confirm the equipment has been taken without my consent.'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe the circumstances of the theft',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.router.maybePop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Submit Theft Report', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
