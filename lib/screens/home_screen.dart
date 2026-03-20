import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/hero_section.dart';
import 'package:nonprofit_app/widgets/impact_story.dart';
import 'package:nonprofit_app/widgets/photo_gallery.dart';
import 'package:nonprofit_app/widgets/video_section.dart';
import 'package:nonprofit_app/widgets/share_mission.dart';
import 'package:nonprofit_app/widgets/qr_instructions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              HeroSection(),
              ImpactStory(),
              PhotoGallery(),
              SizedBox(height: 24),
              VideoSection(),
              SizedBox(height: 24),
              ShareMission(),
              QrInstructions(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
