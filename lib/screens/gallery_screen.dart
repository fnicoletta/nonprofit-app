import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/photo_gallery.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            PhotoGallery(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
