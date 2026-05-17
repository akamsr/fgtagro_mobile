import 'package:fgtagro_mobile/modules/business/rental/widgets/publication_steps/common.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PhotosStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String, dynamic) onUpdate;

  const PhotosStep({super.key, required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final slots = [
      {'key': 'front', 'label': 'Front view'},
      {'key': 'right_side', 'label': 'Right side view'},
      {'key': 'dashboard', 'label': 'Dashboard / controls'},
      {'key': 'engine', 'label': 'Engine compartment'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Equipment Photos',
          subtitle:
              'Please provide high-quality photos from the angles specified below. This helps building trust with potential tenants.',
        ),
        const FormLabel(label: 'Mandatory Photos (4)', required: true),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final photoUrl = data['photoSlots']?[slot['key']];
            return _PhotoSlot(
              label: slot['label']!,
              url: photoUrl,
              onTap: () {
                // Simulate photo upload
                final mockUrl = 'https://example.com/photo_${slot['key']}.jpg';
                final currentSlots = Map<String, String>.from(
                  data['photoSlots'] ?? {},
                );
                currentSlots[slot['key']!] = mockUrl;
                onUpdate('photoSlots', currentSlots);
              },
            );
          },
        ),
        const SizedBox(height: 32),
        const FormLabel(label: 'Additional Photos (Optional)'),
        const SizedBox(height: 12),
        _buildAdditionalPhotos(),
        const SizedBox(height: 16),
        Text(
          'Photos must be min 800x800px, max 5MB (JPG/PNG).',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalPhotos() {
    final List<String> photos = data['additionalPhotos'] ?? [];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...photos.map(
          (p) => _PhotoSlot(
            url: p,
            onTap: () {}, // Delete or replace logic
            isSmall: true,
          ),
        ),
        if (photos.length < 6)
          _AddPhotoSlot(
            onTap: () {
              onUpdate('additionalPhotos', [
                ...photos,
                'https://example.com/extra_${photos.length}.jpg',
              ]);
            },
          ),
      ],
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final String? label;
  final String? url;
  final VoidCallback onTap;
  final bool isSmall;

  const _PhotoSlot({
    this.label,
    this.url,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: isSmall ? 80 : null,
        height: isSmall ? 80 : null,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: url != null ? AppColors.primaryColor : Colors.grey.shade200,
            width: url != null ? 1.5 : 1,
          ),
          image: url != null
              ? DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)
              : null,
        ),
        child: url == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.grey.shade400,
                    size: isSmall ? 20 : 28,
                  ),
                  if (label != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        label!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 12,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
      ),
    );
  }
}

class _AddPhotoSlot extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            style: BorderStyle.none,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
