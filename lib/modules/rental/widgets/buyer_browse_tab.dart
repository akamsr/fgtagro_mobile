import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fgtagro_mobile/routes/router.gr.dart';
import '../cubit/buyer_rental.cubit.dart';
import '../cubit/buyer_rental.state.dart';

class BuyerBrowseTab extends StatelessWidget {
  const BuyerBrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerRentalCubit, BuyerRentalState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredEquipment = context.read<BuyerRentalCubit>().getFilteredEquipment();

        return Column(
          children: [
            _buildSearchBar(context),
            _buildFilters(context, state),
            Expanded(
              child: filteredEquipment.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEquipment.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final equipment = filteredEquipment[index];
                        return _buildEquipmentCard(context, equipment);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (val) => context.read<BuyerRentalCubit>().setSearchQuery(val),
        decoration: InputDecoration(
          hintText: 'Search equipment type, brand, model...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, BuyerRentalState state) {
    final categories = ['All', 'Tractor', 'Harvester', 'Plough', 'Irrigation Pump', 'Sprayer', 'Other'];
    
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = (state.selectedCategory ?? 'All') == cat;
          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (selected) {
              context.read<BuyerRentalCubit>().setCategory(selected ? cat : 'All');
            },
            selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
            checkmarkColor: AppColors.primaryColor,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No equipment found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or search terms.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(BuildContext context, dynamic equipment) {
    final currencyFormat = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 0);
    
    return Container(
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
          // Cover photo
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: equipment.photoSlots.containsKey('front')
                      ? Image.network(
                          equipment.photoSlots['front']!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.agriculture, size: 60, color: Colors.grey),
                        )
                      : const Icon(Icons.agriculture, size: 60, color: Colors.grey),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
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
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${equipment.brand} ${equipment.model} ${equipment.yearOfManufacture ?? ""}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
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
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    const Text('4.7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const Text(' · 23 rentals', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              currencyFormat.format(equipment.dailyRate),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                            ),
                            const Text('/day', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Deposit: ${currencyFormat.format(equipment.securityDeposit)}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.router.push(BuyerEquipmentDetailRoute(equipment: equipment));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('View details', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
