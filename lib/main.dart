import 'package:flutter/material.dart';
import 'package:nonprofit_app/app.dart';
import 'package:nonprofit_app/services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetService.initialize();
  runApp(const NonprofitApp());
}
