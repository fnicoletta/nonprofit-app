import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/video_section.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            VideoSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
