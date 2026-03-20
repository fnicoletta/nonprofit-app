import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WidgetService {
  static Future<void> initialize() async {
    // home_widget only works on iOS and Android, skip on web/desktop.
    if (kIsWeb) return;

    final platform = defaultTargetPlatform;
    if (platform == TargetPlatform.iOS) {
      await HomeWidget.setAppGroupId(AppConstants.widgetAppGroupId);
    }

    if (platform != TargetPlatform.iOS && platform != TargetPlatform.android) {
      return;
    }

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
