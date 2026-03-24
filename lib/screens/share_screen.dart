import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/share_mission.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share the Mission')),
      body: const SingleChildScrollView(
        child: ShareMission(),
      ),
    );
  }
}
