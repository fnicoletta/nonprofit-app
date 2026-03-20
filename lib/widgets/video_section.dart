import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = YoutubePlayerController(
        initialVideoId: AppConstants.youtubeVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'See Our Work',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          if (_controller != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).colorScheme.primary,
              ),
            )
          else
            _buildWebFallback(context),
        ],
      ),
    );
  }

  Widget _buildWebFallback(BuildContext context) {
    final url = 'https://www.youtube.com/watch?v=${AppConstants.youtubeVideoId}';
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          color: Colors.black87,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Tap to watch on YouTube',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
