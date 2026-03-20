import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';

class ImpactStory extends StatelessWidget {
  const ImpactStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.impactStoryTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.impactStoryBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
