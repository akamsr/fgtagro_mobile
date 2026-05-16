import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class NameCategoryStep extends StatelessWidget {
  final TextEditingController nameController;
  final List<String> categoryPath;
  final Function(List<String>) onCategorySelect;

  const NameCategoryStep({
    super.key,
    required this.nameController,
    required this.categoryPath,
    required this.onCategorySelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identity',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 32),
        const Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'e.g. Organic NPK Fertilizer 15-15-15',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            counterText: '',
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${nameController.text.length}/100', style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ),
        const SizedBox(height: 24),
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (categoryPath.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              categoryPath.join(' > '),
              style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        _CategoryTreeSelector(onSelect: onCategorySelect),
      ],
    );
  }
}

class _CategoryTreeSelector extends StatefulWidget {
  final Function(List<String>) onSelect;
  const _CategoryTreeSelector({required this.onSelect});

  @override
  State<_CategoryTreeSelector> createState() => _CategoryTreeSelectorState();
}

class _CategoryTreeSelectorState extends State<_CategoryTreeSelector> {
  // Mock Category Data
  final Map<String, dynamic> categories = {
    'Inputs': {
      'Fertilizers': ['NPK', 'Urea', 'Organic'],
      'Seeds': ['Maize', 'Rice', 'Vegetables'],
      'Pesticides': ['Herbicides', 'Fungicides'],
    },
    'Livestock': {
      'Poultry': ['Chicks', 'Layers', 'Broilers'],
      'Cattle': ['Beef', 'Dairy'],
    },
    'Equipment': ['Hand Tools', 'Tractors', 'Irrigation'],
    'Produce': ['Fruits', 'Vegetables', 'Grains'],
  };

  String? _expandedLevel1;
  String? _expandedLevel2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: categories.keys.map((cat) {
          final isExpanded = _expandedLevel1 == cat;
          final value = categories[cat];

          return Column(
            children: [
              ListTile(
                title: Text(cat, style: TextStyle(fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal)),
                trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20),
                onTap: () => setState(() => _expandedLevel1 = isExpanded ? null : cat),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildSubCategories(cat, value),
                ),
              if (cat != categories.keys.last) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubCategories(String parent, dynamic value) {
    if (value is List) {
      return Column(
        children: value.map((sub) => ListTile(
          title: Text(sub),
          onTap: () => widget.onSelect([parent, sub]),
          dense: true,
        )).toList(),
      );
    } else if (value is Map) {
      return Column(
        children: value.keys.map((sub) {
          final isExpanded = _expandedLevel2 == sub;
          return Column(
            children: [
              ListTile(
                title: Text(sub),
                trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 18),
                onTap: () => setState(() => _expandedLevel2 = isExpanded ? null : sub),
                dense: true,
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    children: (value[sub] as List).map((leaf) => ListTile(
                      title: Text(leaf),
                      onTap: () => widget.onSelect([parent, sub, leaf]),
                      dense: true,
                    )).toList(),
                  ),
                ),
            ],
          );
        }).toList(),
      );
    }
    return const SizedBox();
  }
}
