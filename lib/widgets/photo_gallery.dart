import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Gallery',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: AppConstants.galleryImages.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final imagePath = AppConstants.galleryImages[index];
              return GestureDetector(
                onTap: () => _showFullImage(context, imagePath),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 280,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
