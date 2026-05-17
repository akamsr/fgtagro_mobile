import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class DocumentsStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const DocumentsStep({super.key, required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Equipment Documents',
          subtitle:
              'Upload the necessary legal documents to verify your equipment. PDF or JPG formats are accepted.',
        ),
        _buildDocSlot(
          title: 'Registration Certificate',
          description: 'Required for all motorized equipment.',
          key: 'registration',
          required: true,
        ),
        _buildDocSlot(
          title: 'Insurance Certificate',
          description: 'Must be active and not expired.',
          key: 'insurance',
          required: true,
        ),
        _buildDocSlot(
          title: 'Technical Inspection',
          description: 'Recent safety inspection report.',
          key: 'inspection',
          required: true,
        ),
        _buildDocSlot(
          title: 'Purchase Invoice',
          description: 'Optional but helps building trust.',
          key: 'invoice',
          required: false,
        ),
      ],
    );
  }

  Widget _buildDocSlot({
    required String title,
    required String description,
    required String key,
    bool required = false,
  }) {
    final doc = data['documents']?[key];
    final bool isUploaded = doc != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUploaded
            ? AppColors.primaryTint.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded ? AppColors.primaryColor : Colors.grey.shade200,
          width: isUploaded ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUploaded ? AppColors.primaryColor : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUploaded ? Icons.check : Icons.description_outlined,
              color: isUploaded ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (required)
                      const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                Text(
                  isUploaded ? 'Uploaded on 12 May 2024' : description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUploaded
                        ? Colors.green.shade700
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isUploaded)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: () {
                final currentDocs = Map<String, dynamic>.from(
                  data['documents'] ?? {},
                );
                currentDocs.remove(key);
                onUpdate('documents', currentDocs);
              },
            )
          else
            TextButton(
              onPressed: () {
                // Simulate upload
                final currentDocs = Map<String, dynamic>.from(
                  data['documents'] ?? {},
                );
                currentDocs[key] = {
                  'name': '$title.pdf',
                  'url': 'https://example.com/$key.pdf',
                  'date': DateTime.now().toIso8601String(),
                };
                onUpdate('documents', currentDocs);
              },
              child: const Text('UPLOAD'),
            ),
        ],
      ),
    );
  }
}
