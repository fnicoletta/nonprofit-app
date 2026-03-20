import 'package:flutter/material.dart';

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
              Placeholder(fallbackHeight: 300),
              Placeholder(fallbackHeight: 200),
              Placeholder(fallbackHeight: 200),
              Placeholder(fallbackHeight: 250),
              Placeholder(fallbackHeight: 200),
              Placeholder(fallbackHeight: 400),
            ],
          ),
        ),
      ),
    );
  }
}
