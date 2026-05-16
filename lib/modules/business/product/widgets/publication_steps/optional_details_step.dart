import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class OptionalDetailsStep extends StatelessWidget {
  final Map<String, String> details;

  const OptionalDetailsStep({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optional Specs',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add more details to help buyers decide. These fields vary based on your selected category.',
          style: TextStyle(color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 32),
        _buildField('Variety / Grade', 'e.g. Grade A, IR64'),
        _buildField('Harvest Date', 'DD/MM/YYYY'),
        _buildField('Expiry Date', 'DD/MM/YYYY'),
        _buildField('NPK Ratio (for Fertilizers)', 'e.g. 15-15-15'),
        _buildField('Breed (for Livestock)', 'e.g. Holstein'),
        const SizedBox(height: 24),
        const Text('Certifications (PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: Colors.grey),
              const SizedBox(width: 12),
              Text('Upload certificate (Organic, Fair Trade...)', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: const Text('OPTIONAL', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ],
      ),
    );
  }
}
