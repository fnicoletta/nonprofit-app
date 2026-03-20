# Lockscreen QR Widget PoC — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a Flutter PoC app with a lock screen QR code widget that links to a nonprofit's donation page, on both iOS and Android.

**Architecture:** Single-screen Flutter app with hardcoded content (impact story, photos, video, share section, QR code). Native lock screen widgets on iOS (WidgetKit/SwiftUI) and Android (AppWidgetProvider/Kotlin) bridged via the `home_widget` package. No backend.

**Tech Stack:** Flutter, Dart, SwiftUI, Kotlin, `qr_flutter`, `home_widget`, `youtube_player_flutter`, `share_plus`, `url_launcher`

**Design doc:** `docs/plans/2026-03-20-lockscreen-qr-widget-design.md`

---

### Task 1: Install Flutter and Create Project

**Files:**
- Create: Flutter project scaffold at `/home/wizard/Projects/nonprofit_app/`

**Step 1: Install Flutter SDK**

Run:
```bash
yay -S --noconfirm flutter
```

If that fails or is outdated, install manually:
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter-sdk
export PATH="$HOME/flutter-sdk/bin:$PATH"
echo 'export PATH="$HOME/flutter-sdk/bin:$PATH"' >> ~/.bashrc
```

**Step 2: Verify Flutter installation**

Run: `flutter --version`
Expected: Flutter 3.x.x stable channel

Run: `flutter doctor`
Expected: Shows Flutter installed. Android/iOS toolchains may show warnings — that's fine for now.

**Step 3: Create the Flutter project**

Since we already have a git repo with docs, create the Flutter project in a temp directory and move it:

```bash
cd /tmp
flutter create --org com.nonprofit --project-name nonprofit_app nonprofit_app_scaffold
```

Then copy the Flutter project files into our repo:
```bash
cp -r /tmp/nonprofit_app_scaffold/* /home/wizard/Projects/nonprofit_app/
cp /tmp/nonprofit_app_scaffold/.gitignore /home/wizard/Projects/nonprofit_app/
cp -r /tmp/nonprofit_app_scaffold/.metadata /home/wizard/Projects/nonprofit_app/ 2>/dev/null
rm -rf /tmp/nonprofit_app_scaffold
```

**Step 4: Verify project runs**

Run:
```bash
cd /home/wizard/Projects/nonprofit_app
flutter pub get
```
Expected: Dependencies resolved successfully.

**Step 5: Commit**

```bash
git add -A
git commit -m "feat: scaffold Flutter project"
```

---

### Task 2: Add Dependencies

**Files:**
- Modify: `pubspec.yaml`

**Step 1: Add all required packages to pubspec.yaml**

Add these to the `dependencies` section in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  qr_flutter: ^4.1.0
  home_widget: ^0.7.0
  youtube_player_flutter: ^9.1.1
  share_plus: ^10.1.4
  url_launcher: ^6.3.1
```

Remove `cupertino_icons` if present (we won't use it).

**Step 2: Add assets section to pubspec.yaml**

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

**Step 3: Create assets directory**

```bash
mkdir -p /home/wizard/Projects/nonprofit_app/assets/images
```

**Step 4: Add placeholder images**

Generate 5 simple colored placeholder PNGs using Flutter's test utilities, or create them with ImageMagick if available:

```bash
# Check if ImageMagick is available
which convert || yay -S --noconfirm imagemagick
```

Create placeholder images:
```bash
cd /home/wizard/Projects/nonprofit_app/assets/images
convert -size 800x600 xc:#4A90D9 placeholder_1.png
convert -size 800x600 xc:#7B68EE placeholder_2.png
convert -size 800x600 xc:#50C878 placeholder_3.png
convert -size 800x600 xc:#FF6B6B placeholder_4.png
convert -size 800x600 xc:#FFD700 placeholder_5.png
convert -size 400x400 xc:#2C3E50 -fill white -gravity center -pointsize 48 -annotate +0+0 "LOGO" logo.png
convert -size 1200x400 xc:#1A1A2E hero_bg.png
```

**Step 5: Run pub get**

Run: `flutter pub get`
Expected: All dependencies resolve successfully.

**Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock assets/
git commit -m "feat: add dependencies and placeholder assets"
```

---

### Task 3: Constants and Theme

**Files:**
- Create: `lib/constants/app_constants.dart`
- Create: `lib/constants/app_theme.dart`

**Step 1: Create app_constants.dart**

```dart
// lib/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String donationUrl =
      'https://nonprofit.org/donate?utm_source=app_widget&utm_medium=qr';

  static const String orgName = 'Hope Foundation';
  static const String tagline = 'Building brighter futures, one community at a time';

  static const String youtubeVideoId = 'dQw4w9WgXcQ'; // Placeholder

  static const String impactStoryTitle = 'Our Impact';
  static const String impactStoryBody =
      'Since 2015, Hope Foundation has served over 50,000 families across 12 '
      'countries. Our programs focus on education, clean water access, and '
      'sustainable agriculture — giving communities the tools they need to '
      'thrive.\n\n'
      'Last year alone, we built 34 schools, installed 120 clean water wells, '
      'and trained 2,000 local farmers in sustainable practices. Every dollar '
      'donated goes directly to the communities that need it most.\n\n'
      'With your support, we can reach 100,000 families by 2027. Together, '
      'we are proof that small actions create lasting change.';

  static const String shareMissionTitle = 'Share the Mission';
  static const String shareMissionBody =
      'Help us spread the word. Share our donation link with friends and '
      'family — every share has the potential to change a life.';

  static const String shareMessage =
      'Support Hope Foundation and help build brighter futures! '
      'Donate here: $donationUrl';

  static const List<String> galleryImages = [
    'assets/images/placeholder_1.png',
    'assets/images/placeholder_2.png',
    'assets/images/placeholder_3.png',
    'assets/images/placeholder_4.png',
    'assets/images/placeholder_5.png',
  ];

  // Widget constants
  static const String widgetAppGroupId = 'group.com.nonprofit.nonprofitapp';
  static const String widgetQrKey = 'qr_code_image';
}
```

**Step 2: Create app_theme.dart**

```dart
// lib/constants/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF4A90D9);
  static const Color accentColor = Color(0xFF50C878);
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color cardBg = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: textSecondary,
          ),
        ),
        useMaterial3: true,
      );
}
```

**Step 3: Verify no syntax errors**

Run: `flutter analyze lib/constants/`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/constants/
git commit -m "feat: add app constants and theme"
```

---

### Task 4: App Shell and Home Screen Scaffold

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/app.dart`
- Create: `lib/screens/home_screen.dart`

**Step 1: Create app.dart**

```dart
// lib/app.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_theme.dart';
import 'package:nonprofit_app/screens/home_screen.dart';

class NonprofitApp extends StatelessWidget {
  const NonprofitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope Foundation',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

**Step 2: Create home_screen.dart (scaffold only)**

```dart
// lib/screens/home_screen.dart

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
            children: [
              // Task 5: HeroSection
              const Placeholder(fallbackHeight: 300, label: 'Hero Section'),
              // Task 6: ImpactStory
              const Placeholder(fallbackHeight: 200, label: 'Impact Story'),
              // Task 7: PhotoGallery
              const Placeholder(fallbackHeight: 200, label: 'Photo Gallery'),
              // Task 8: VideoSection
              const Placeholder(fallbackHeight: 250, label: 'Video Section'),
              // Task 9: ShareMission
              const Placeholder(fallbackHeight: 200, label: 'Share Mission'),
              // Task 10: QrInstructions
              const Placeholder(fallbackHeight: 400, label: 'QR & Instructions'),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 3: Update main.dart**

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NonprofitApp());
}
```

**Step 4: Verify it compiles**

Run: `flutter analyze`
Expected: No issues found.

**Step 5: Commit**

```bash
git add lib/main.dart lib/app.dart lib/screens/
git commit -m "feat: add app shell and home screen scaffold"
```

---

### Task 5: Hero Section Widget

**Files:**
- Create: `lib/widgets/hero_section.dart`
- Modify: `lib/screens/home_screen.dart` — replace Hero Placeholder

**Step 1: Create hero_section.dart**

```dart
// lib/widgets/hero_section.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:nonprofit_app/constants/app_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hero_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withAlpha(25),
              Colors.black.withAlpha(178),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.orgName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.tagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Update home_screen.dart**

Replace the Hero Section `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/hero_section.dart';

// In the Column children, replace Hero Placeholder:
const HeroSection(),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/hero_section.dart lib/screens/home_screen.dart
git commit -m "feat: add hero section widget"
```

---

### Task 6: Impact Story Widget

**Files:**
- Create: `lib/widgets/impact_story.dart`
- Modify: `lib/screens/home_screen.dart` — replace Impact Story Placeholder

**Step 1: Create impact_story.dart**

```dart
// lib/widgets/impact_story.dart

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
```

**Step 2: Update home_screen.dart**

Replace the Impact Story `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/impact_story.dart';

// In the Column children:
const ImpactStory(),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/impact_story.dart lib/screens/home_screen.dart
git commit -m "feat: add impact story widget"
```

---

### Task 7: Photo Gallery Widget

**Files:**
- Create: `lib/widgets/photo_gallery.dart`
- Modify: `lib/screens/home_screen.dart` — replace Photo Gallery Placeholder

**Step 1: Create photo_gallery.dart**

```dart
// lib/widgets/photo_gallery.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Gallery',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: AppConstants.galleryImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final imagePath = AppConstants.galleryImages[index];
              return GestureDetector(
                onTap: () => _showFullImage(context, imagePath),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 280,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
```

**Step 2: Update home_screen.dart**

Replace the Photo Gallery `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/photo_gallery.dart';

// In the Column children:
const PhotoGallery(),
const SizedBox(height: 24),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/photo_gallery.dart lib/screens/home_screen.dart
git commit -m "feat: add photo gallery widget"
```

---

### Task 8: Video Section Widget

**Files:**
- Create: `lib/widgets/video_section.dart`
- Modify: `lib/screens/home_screen.dart` — replace Video Section Placeholder

**Step 1: Create video_section.dart**

```dart
// lib/widgets/video_section.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: AppConstants.youtubeVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'See Our Work',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Update home_screen.dart**

Replace the Video Section `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/video_section.dart';

// In the Column children:
const VideoSection(),
const SizedBox(height: 24),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/video_section.dart lib/screens/home_screen.dart
git commit -m "feat: add video section widget"
```

---

### Task 9: Share the Mission Widget

**Files:**
- Create: `lib/widgets/share_mission.dart`
- Modify: `lib/screens/home_screen.dart` — replace Share Mission Placeholder

**Step 1: Create share_mission.dart**

```dart
// lib/widgets/share_mission.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
                      SharePlus.instance.share(
                        ShareParams(text: AppConstants.shareMessage),
                      );
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
```

**Step 2: Update home_screen.dart**

Replace the Share Mission `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/share_mission.dart';

// In the Column children:
const ShareMission(),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/share_mission.dart lib/screens/home_screen.dart
git commit -m "feat: add share the mission widget"
```

---

### Task 10: QR Code Display and Widget Instructions

**Files:**
- Create: `lib/widgets/qr_instructions.dart`
- Modify: `lib/screens/home_screen.dart` — replace QR & Instructions Placeholder

**Step 1: Create qr_instructions.dart**

```dart
// lib/widgets/qr_instructions.dart

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
      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
```

**Step 2: Update home_screen.dart**

Replace the QR & Instructions `Placeholder` with:
```dart
import 'package:nonprofit_app/widgets/qr_instructions.dart';

// In the Column children:
const QrInstructions(),
const SizedBox(height: 40),
```

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 4: Commit**

```bash
git add lib/widgets/qr_instructions.dart lib/screens/home_screen.dart
git commit -m "feat: add QR code display and widget instructions"
```

---

### Task 11: QR Code Image Generation and home_widget Bridge

**Files:**
- Create: `lib/services/widget_service.dart`
- Modify: `lib/main.dart` — call widget service on startup

**Step 1: Create widget_service.dart**

This service generates the QR code as a PNG and saves it to shared storage so native widgets can read it.

```dart
// lib/services/widget_service.dart

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_widget/home_widget.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

class WidgetService {
  static Future<void> initialize() async {
    // Set the app group ID for iOS
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(AppConstants.widgetAppGroupId);
    }

    // Generate and save the QR code image
    await _generateAndSaveQrCode();

    // Update the widget
    await HomeWidget.updateWidget(
      iOSName: 'QRCodeWidget',
      androidName: 'QRCodeWidgetProvider',
    );
  }

  static Future<void> _generateAndSaveQrCode() async {
    final qrPainter = QrPainter(
      data: AppConstants.donationUrl,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    );

    final size = const Size(400, 400);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // White background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    // Draw QR code with padding
    const padding = 20.0;
    qrPainter.paint(
      canvas,
      Size(size.width - padding * 2, size.height - padding * 2),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/qr_code.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // Save the file path so the native widget can find it
    await HomeWidget.saveWidgetData<String>(
      AppConstants.widgetQrKey,
      file.path,
    );
  }
}
```

**Step 2: Update main.dart**

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:nonprofit_app/app.dart';
import 'package:nonprofit_app/services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetService.initialize();
  runApp(const NonprofitApp());
}
```

**Step 3: Add path_provider to pubspec.yaml**

Add under dependencies:
```yaml
  path_provider: ^2.1.5
```

Run: `flutter pub get`

**Step 4: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 5: Commit**

```bash
git add lib/services/widget_service.dart lib/main.dart pubspec.yaml pubspec.lock
git commit -m "feat: add QR code generation and home_widget bridge"
```

---

### Task 12: Android Widget (Kotlin)

**Files:**
- Create: `android/app/src/main/kotlin/.../QRCodeWidgetProvider.kt`
- Create: `android/app/src/main/res/layout/qr_widget_layout.xml`
- Create: `android/app/src/main/res/xml/qr_widget_info.xml`
- Modify: `android/app/src/main/AndroidManifest.xml`

**Step 1: Create the widget layout**

Create `android/app/src/main/res/layout/qr_widget_layout.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@android:color/white"
    android:padding="8dp">

    <ImageView
        android:id="@+id/qr_image"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:scaleType="fitCenter"
        android:contentDescription="Donation QR Code" />

</RelativeLayout>
```

**Step 2: Create the widget info XML**

Create `android/app/src/main/res/xml/qr_widget_info.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/qr_widget_layout"
    android:minWidth="110dp"
    android:minHeight="110dp"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen|keyguard"
    android:description="@string/widget_description" />
```

**Step 3: Add string resource for widget description**

Add to `android/app/src/main/res/values/strings.xml` (create if it doesn't exist):
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="widget_description">Shows the donation QR code on your home or lock screen</string>
</resources>
```

**Step 4: Create the Kotlin widget provider**

Find the package path first by checking `android/app/src/main/kotlin/` structure. The package will be `com.nonprofit.nonprofit_app`.

Create `android/app/src/main/kotlin/com/nonprofit/nonprofit_app/QRCodeWidgetProvider.kt`:
```kotlin
package com.nonprofit.nonprofit_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

class QRCodeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.qr_widget_layout)

            // Get the QR code image path from shared preferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val imagePath = widgetData.getString("qr_code_image", null)

            if (imagePath != null) {
                val file = File(imagePath)
                if (file.exists()) {
                    val bitmap = BitmapFactory.decodeFile(imagePath)
                    views.setImageViewBitmap(R.id.qr_image, bitmap)
                }
            }

            // Tap to open the app
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (intent != null) {
                val pendingIntent = PendingIntent.getActivity(
                    context, 0, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.qr_image, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
```

**Step 5: Register widget in AndroidManifest.xml**

Add inside the `<application>` tag in `android/app/src/main/AndroidManifest.xml`:
```xml
<receiver android:name=".QRCodeWidgetProvider"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/qr_widget_info" />
</receiver>
```

**Step 6: Verify**

Run: `flutter analyze`
Expected: No issues found.

**Step 7: Commit**

```bash
git add android/
git commit -m "feat: add Android lock screen/home screen QR code widget"
```

---

### Task 13: iOS Widget (SwiftUI/WidgetKit)

**Files:**
- Create: `ios/QRCodeWidget/QRCodeWidget.swift`
- Create: `ios/QRCodeWidget/QRCodeWidgetBundle.swift`
- Create: `ios/QRCodeWidget/Info.plist`
- Modify: `ios/Podfile`
- Modify: Xcode project configuration

> **Note:** This task requires Xcode and macOS. If developing on Linux, create the files and document the Xcode setup steps to be completed on a Mac later.

**Step 1: Create the widget extension directory**

```bash
mkdir -p ios/QRCodeWidget
```

**Step 2: Create QRCodeWidgetBundle.swift**

```swift
// ios/QRCodeWidget/QRCodeWidgetBundle.swift

import WidgetKit
import SwiftUI

@main
struct QRCodeWidgetBundle: WidgetBundle {
    var body: some Widget {
        QRCodeWidget()
    }
}
```

**Step 3: Create QRCodeWidget.swift**

```swift
// ios/QRCodeWidget/QRCodeWidget.swift

import WidgetKit
import SwiftUI

struct QRCodeEntry: TimelineEntry {
    let date: Date
    let image: UIImage?
}

struct QRCodeProvider: TimelineProvider {
    let appGroupId = "group.com.nonprofit.nonprofitapp"
    let imageKey = "qr_code_image"

    func placeholder(in context: Context) -> QRCodeEntry {
        QRCodeEntry(date: Date(), image: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (QRCodeEntry) -> Void) {
        let entry = QRCodeEntry(date: Date(), image: loadQRImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QRCodeEntry>) -> Void) {
        let entry = QRCodeEntry(date: Date(), image: loadQRImage())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadQRImage() -> UIImage? {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        guard let imagePath = userDefaults?.string(forKey: imageKey) else { return nil }
        return UIImage(contentsOfFile: imagePath)
    }
}

struct QRCodeWidgetEntryView: View {
    var entry: QRCodeProvider.Entry

    var body: some View {
        if let image = entry.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(4)
        } else {
            Image(systemName: "qrcode")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct QRCodeWidget: Widget {
    let kind: String = "QRCodeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QRCodeProvider()) { entry in
            QRCodeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Donation QR Code")
        .description("Shows the donation QR code for quick access.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}
```

**Step 4: Create Info.plist for the widget extension**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>
    </dict>
</dict>
</plist>
```

**Step 5: Document Xcode setup (to be done on macOS)**

Create `docs/ios-widget-setup.md` with these steps:
1. Open `ios/Runner.xcworkspace` in Xcode
2. File > New > Target > Widget Extension, name it "QRCodeWidget"
3. Replace generated files with the ones created above
4. Add App Group capability to both Runner and QRCodeWidget targets: `group.com.nonprofit.nonprofitapp`
5. Set deployment target to iOS 16.0 for the widget extension
6. Update the Podfile to include the widget extension target

**Step 6: Commit**

```bash
git add ios/QRCodeWidget/ docs/ios-widget-setup.md
git commit -m "feat: add iOS lock screen QR code widget (requires Xcode setup)"
```

---

### Task 14: Final Integration and Smoke Test

**Files:**
- Verify: All files compile and analyze cleanly

**Step 1: Run full analysis**

Run: `flutter analyze`
Expected: No issues found.

**Step 2: Run pub get to verify all deps resolve**

Run: `flutter pub get`
Expected: Dependencies resolved successfully.

**Step 3: Verify project structure matches design**

Run: `find lib/ -name "*.dart" | sort`
Expected output:
```
lib/app.dart
lib/constants/app_constants.dart
lib/constants/app_theme.dart
lib/main.dart
lib/screens/home_screen.dart
lib/services/widget_service.dart
lib/widgets/hero_section.dart
lib/widgets/impact_story.dart
lib/widgets/photo_gallery.dart
lib/widgets/qr_instructions.dart
lib/widgets/share_mission.dart
lib/widgets/video_section.dart
```

**Step 4: Try building for available platforms**

If an Android SDK is available:
```bash
flutter build apk --debug
```

If on macOS with Xcode:
```bash
flutter build ios --debug --no-codesign
```

**Step 5: Final commit**

```bash
git add -A
git commit -m "chore: final integration cleanup"
```

---

## Summary

| Task | Description | Dependencies |
|------|-------------|--------------|
| 1 | Install Flutter & create project | None |
| 2 | Add dependencies & assets | Task 1 |
| 3 | Constants & theme | Task 2 |
| 4 | App shell & home screen scaffold | Task 3 |
| 5 | Hero section widget | Task 4 |
| 6 | Impact story widget | Task 4 |
| 7 | Photo gallery widget | Task 4 |
| 8 | Video section widget | Task 4 |
| 9 | Share the mission widget | Task 4 |
| 10 | QR code display & instructions | Task 4 |
| 11 | QR image generation & widget bridge | Task 10 |
| 12 | Android widget (Kotlin) | Task 11 |
| 13 | iOS widget (SwiftUI) | Task 11 |
| 14 | Final integration & smoke test | All |

Tasks 5-10 can be done in parallel after Task 4.
Tasks 12-13 can be done in parallel after Task 11.
