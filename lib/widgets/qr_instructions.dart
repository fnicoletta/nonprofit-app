import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nonprofit_app/constants/app_constants.dart';

class QrInstructions extends StatelessWidget {
  const QrInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Donation QR Code',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Scan this code or add it to your lock screen widget',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: AppConstants.donationUrl,
              version: QrVersions.auto,
              size: 220,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          const SizedBox(height: 32),
          _buildInstructionTabs(context),
        ],
      ),
    );
  }

  Widget _buildInstructionTabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Text(
            'Add Widget to Lock Screen',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const TabBar(
            tabs: [
              Tab(text: 'iPhone'),
              Tab(text: 'Android'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: TabBarView(
              children: [
                _buildIosInstructions(context),
                _buildAndroidInstructions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIosInstructions(BuildContext context) {
    return _buildStepList(context, [
      'Long press on your iPhone lock screen',
      'Tap "Customize" then select the lock screen',
      'Tap the widget area below the time',
      'Search for "${AppConstants.orgName}"',
      'Tap the QR code widget to add it',
      'Tap "Done" to save',
    ]);
  }

  Widget _buildAndroidInstructions(BuildContext context) {
    return _buildStepList(context, [
      'Long press on your home screen',
      'Tap "Widgets"',
      'Search for "${AppConstants.orgName}"',
      'Long press the QR code widget and drag to your screen',
      'The widget will also appear on your lock screen if enabled',
    ]);
  }

  Widget _buildStepList(BuildContext context, List<String> steps) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  steps[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
