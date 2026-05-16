import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/modules/business/rental/widgets/equipment_card.dart';
import 'package:flutter/material.dart';

class EquipmentTab extends StatelessWidget {
  final List<EquipmentModel> equipment;

  const EquipmentTab({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    if (equipment.isEmpty) {
      return const Center(child: Text('No equipment listed yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: equipment.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return EquipmentCard(equipment: equipment[index]);
      },
    );
  }
}
