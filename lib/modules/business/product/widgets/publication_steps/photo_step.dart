import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class PhotoStep extends StatelessWidget {
  final List<String> photos;
  final Function(List<String>) onUpdate;

  const PhotoStep({super.key, required this.photos, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Photos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload between 2 and 5 photos. High-quality photos increase sales. Drag to reorder. The first photo is the cover.',
          style: TextStyle(color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 32),
        ReorderableGrid(photos: photos, onUpdate: onUpdate),
      ],
    );
  }
}

class ReorderableGrid extends StatelessWidget {
  final List<String> photos;
  final Function(List<String>) onUpdate;

  const ReorderableGrid({
    super.key,
    required this.photos,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        if (index < photos.length) {
          return _PhotoTile(
            url: photos[index],
            isCover: index == 0,
            onRemove: () {
              final newPhotos = List<String>.from(photos)..removeAt(index);
              onUpdate(newPhotos);
            },
          );
        } else {
          return _UploadPlaceholder(
            onTap: () {
              // Mock adding a photo
              final newPhotos = List<String>.from(photos)
                ..add('https://picsum.photos/800/800?random=$index');
              onUpdate(newPhotos);
            },
          );
        }
      },
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String url;
  final bool isCover;
  final VoidCallback onRemove;

  const _PhotoTile({
    required this.url,
    required this.isCover,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            border: isCover
                ? Border.all(color: AppColors.primaryColor, width: 2)
                : null,
          ),
        ),
        if (isCover)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'COVER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: Colors.grey.shade400,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
