import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/qr_instructions.dart';

class WidgetSetupScreen extends StatelessWidget {
  const WidgetSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Setup')),
      body: const SingleChildScrollView(
        child: QrInstructions(),
      ),
    );
  }
}
