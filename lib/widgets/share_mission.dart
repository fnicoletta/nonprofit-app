import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:nonprofit_app/constants/app_constants.dart';

class ShareMission extends StatelessWidget {
  const ShareMission({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.shareMissionTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.shareMissionBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      share_plus.Share.share(AppConstants.shareMessage);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(text: AppConstants.donationUrl),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Link'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
