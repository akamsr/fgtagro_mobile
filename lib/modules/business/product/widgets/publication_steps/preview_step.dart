import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PreviewStep extends StatelessWidget {
  final List<String> photos;
  final String name;
  final String category;
  final String price;
  final String unit;
  final String stock;
  final String description;
  final Map<String, String> details;

  const PreviewStep({
    super.key,
    required this.photos,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    required this.description,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Final Preview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Review your product as it will appear to buyers.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Mock Photo Carousel
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            image: photos.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(photos[0]),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photos.isEmpty
              ? const Icon(Icons.image, size: 64, color: Colors.grey)
              : null,
        ),

        const SizedBox(height: 24),
        Text(
          category,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name.isEmpty ? 'Product Name' : name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$price FCFA / $unit',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Available Stock: $stock $unit',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),

        const Divider(height: 48),

        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          description.isEmpty ? 'No description provided.' : description,
          style: const TextStyle(height: 1.6, color: Colors.black87),
        ),

        const Divider(height: 48),

        const Text(
          'Specifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _buildSpecRow('Variety', 'Grade A'),
        _buildSpecRow('Origin', 'Bafoussam, West Cameroon'),
        _buildSpecRow('Harvest', 'May 2024'),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
