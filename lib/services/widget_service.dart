import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WidgetService {
  static Future<void> initialize() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(AppConstants.widgetAppGroupId);
    }

    // Use HomeWidget.renderFlutterWidget to render the QR code to an image
    // and save it to shared storage for the native widget.
    await HomeWidget.renderFlutterWidget(
      QrImageView(
        data: AppConstants.donationUrl,
        version: QrVersions.auto,
        size: 400,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        backgroundColor: Colors.white,
      ),
      key: AppConstants.widgetQrKey,
      logicalSize: const Size(400, 400),
    );

    await HomeWidget.updateWidget(
      iOSName: 'QRCodeWidget',
      androidName: 'QRCodeWidgetProvider',
    );
  }
}
