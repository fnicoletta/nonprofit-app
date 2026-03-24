import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/impact_story.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Impact')),
      body: const SingleChildScrollView(
        child: ImpactStory(),
      ),
    );
  }
}
