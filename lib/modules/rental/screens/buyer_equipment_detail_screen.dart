import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';

@RoutePage()
class BuyerEquipmentDetailScreen extends StatelessWidget {
  final EquipmentModel equipment;

  const BuyerEquipmentDetailScreen({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Equipment Details', style: TextStyle(color: AppColors.secondaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotoGallery(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildPricingBlock(currencyFormat),
                      const SizedBox(height: 24),
                      _buildSpecsBlock(),
                      const SizedBox(height: 24),
                      _buildAvailabilityCalendar(),
                      const SizedBox(height: 24),
                      _buildGeographicAreaBlock(),
                      const SizedBox(height: 24),
                      _buildConditionsBlock(),
                      const SizedBox(height: 24),
                      _buildOwnerBlock(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyBottomBar(context, currencyFormat),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          if (equipment.photoSlots.containsKey('front'))
            Image.network(
              equipment.photoSlots['front']!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Center(child: Icon(Icons.agriculture, size: 80, color: Colors.grey)),
            )
          else
            const Center(child: Icon(Icons.agriculture, size: 80, color: Colors.grey)),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 0 ? AppColors.primaryColor : Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                equipment.type,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: equipment.isAvailable ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                equipment.isAvailable ? 'Available now' : 'Fully booked',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${equipment.brand} ${equipment.model} ${equipment.yearOfManufacture ?? ""}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${equipment.enginePower?.toInt() ?? 0} ${equipment.enginePowerUnit ?? "HP"} · ${equipment.condition ?? ""}',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            const Text('4.7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Text(' · 23 rentals', style: TextStyle(color: Colors.grey, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingBlock(NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rental Rates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily rate', style: TextStyle(color: Colors.grey)),
              Text(
                '${format.format(equipment.dailyRate)} /day',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryColor),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Security deposit', style: TextStyle(color: Colors.grey)),
              Text(
                format.format(equipment.securityDeposit),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Refundable deposit — held in escrow until return',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.local_gas_station, size: 20, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fuel Policy: ${equipment.fuelPolicy}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      equipment.fuelPolicy == 'Full-to-full'
                          ? 'Return with the same fuel level as received'
                          : 'You pay for all fuel consumed during rental',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Specifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSpecRow('Equipment type', equipment.type),
        _buildSpecRow('Brand / Model', '${equipment.brand} ${equipment.model}'),
        _buildSpecRow('Engine power', '${equipment.enginePower} ${equipment.enginePowerUnit}'),
        _buildSpecRow('Condition', equipment.condition ?? 'Not specified'),
        _buildSpecRow('Min notice period', equipment.noticePeriod),
        _buildSpecRow('Min rental duration', equipment.minDuration),
        _buildSpecRow('Max rental duration', equipment.maxDuration),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            height: 200,
            color: Colors.grey.shade100,
            child: const Center(child: Text('Calendar View Placeholder')),
          ),
        ],
      ),
    );
  }

  Widget _buildGeographicAreaBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Allowed Operating Area', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Icon(Icons.map, size: 48, color: Colors.grey)),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your place of use must be within this area. You will select your exact location during booking.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildConditionsBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              const Text('Rental Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Experience required:', style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text(equipment.experienceLevel, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const Text('Insurance required:', style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text(equipment.tenantInsuranceRequired ? 'Yes - Upload required' : 'No', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOwnerBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Equipment Owner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
              child: const Text('JK', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jean K.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Member since 2022 · Yaoundé', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, NumberFormat format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${format.format(equipment.dailyRate)} /day',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Available now',
                    style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: equipment.isAvailable ? () {
                  context.router.push(BuyerBookingFlowRoute(equipment: equipment));
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  equipment.isAvailable ? 'Book this equipment' : 'Unavailable',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
