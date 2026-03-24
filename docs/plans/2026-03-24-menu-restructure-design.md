# Menu Restructure & QR Sign-up Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restructure the app from a single scrollable page into a menu-based navigation with individual screens for each section, and add a new QR Sign-up feature that generates newsletter sign-up QR codes from email addresses (typed or picked from contacts).

**Architecture:** Replace `HomeScreen`'s single scroll with a menu screen (`MenuScreen`) listing 6 items. Each item pushes a dedicated screen wrapping the existing widget. Add a new `QrSignupScreen` with email input, contact picker, and QR generation. Use `flutter_contacts` for the native contact picker.

**Tech Stack:** Flutter, `flutter_contacts` (new), `qr_flutter` (existing)

---

### Task 1: Add `flutter_contacts` dependency

**Files:**
- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`

**Step 1: Add dependency to pubspec.yaml**

Add `flutter_contacts: ^1.2.0` under `dependencies` in `pubspec.yaml`, after `url_launcher`.

**Step 2: Add Android permission**

Add `<uses-permission android:name="android.permission.READ_CONTACTS"/>` to `android/app/src/main/AndroidManifest.xml` before the `<application>` tag.

**Step 3: Run flutter pub get**

Run: `~/flutter-sdk/bin/flutter pub get`
Expected: Dependencies resolve successfully.

**Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml
git commit -m "feat: add flutter_contacts dependency for contact picker"
```

---

### Task 2: Create individual section screens

Create 5 wrapper screens, each a `Scaffold` with `AppBar` + the existing widget.

**Files:**
- Create: `lib/screens/impact_screen.dart`
- Create: `lib/screens/gallery_screen.dart`
- Create: `lib/screens/video_screen.dart`
- Create: `lib/screens/share_screen.dart`
- Create: `lib/screens/widget_setup_screen.dart`

**Step 1: Create `impact_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/impact_story.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Impact')),
      body: const SingleChildScrollView(
        child: ImpactStory(),
      ),
    );
  }
}
```

**Step 2: Create `gallery_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/photo_gallery.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            PhotoGallery(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
```

**Step 3: Create `video_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nonprofit_app/widgets/video_section.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            VideoSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
```

**Step 4: Create `share_screen.dart`**

```dart
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
```

**Step 5: Create `widget_setup_screen.dart`**

```dart
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
```

**Step 6: Commit**

```bash
git add lib/screens/
git commit -m "feat: add individual section screens wrapping existing widgets"
```

---

### Task 3: Create QR Sign-up screen

**Files:**
- Create: `lib/screens/qr_signup_screen.dart`

**Step 1: Create the QR Sign-up screen**

This screen has:
- A `TextField` for email input
- A "Pick from Contacts" button that opens the native contact picker, fetches the email, and fills the field
- A "Generate QR Code" button
- A displayed QR code once generated

The QR code data is a `mailto:` link that triggers a pre-filled newsletter sign-up email, e.g. `mailto:<email>?subject=Newsletter+Signup`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrSignupScreen extends StatefulWidget {
  const QrSignupScreen({super.key});

  @override
  State<QrSignupScreen> createState() => _QrSignupScreenState();
}

class _QrSignupScreenState extends State<QrSignupScreen> {
  final _emailController = TextEditingController();
  String? _qrData;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickContact() async {
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact == null) return;

      final full = await FlutterContacts.getContact(
        contact.id,
        withProperties: true,
      );
      if (full == null || full.emails.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No email found for that contact')),
          );
        }
        return;
      }

      setState(() {
        _emailController.text = full.emails.first.address;
        _qrData = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access contacts')),
        );
      }
    }
  }

  void _generateQr() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }
    setState(() {
      _qrData = 'mailto:$email?subject=Newsletter%20Signup';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Sign-up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Generate a QR code to sign someone up for the newsletter.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              onChanged: (_) {
                if (_qrData != null) setState(() => _qrData = null);
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickContact,
              icon: const Icon(Icons.contacts_outlined),
              label: const Text('Pick from Contacts'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _generateQr,
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate QR Code'),
            ),
            if (_qrData != null) ...[
              const SizedBox(height: 32),
              Center(
                child: Container(
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
                    data: _qrData!,
                    version: QrVersions.auto,
                    size: 220,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _emailController.text.trim(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add lib/screens/qr_signup_screen.dart
git commit -m "feat: add QR sign-up screen with email input and contact picker"
```

---

### Task 4: Create menu screen and update routing

**Files:**
- Create: `lib/screens/menu_screen.dart`
- Modify: `lib/app.dart` (change `home:` from `HomeScreen` to `MenuScreen`)

**Step 1: Create `menu_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:nonprofit_app/constants/app_constants.dart';
import 'package:nonprofit_app/constants/app_theme.dart';
import 'package:nonprofit_app/screens/impact_screen.dart';
import 'package:nonprofit_app/screens/gallery_screen.dart';
import 'package:nonprofit_app/screens/video_screen.dart';
import 'package:nonprofit_app/screens/share_screen.dart';
import 'package:nonprofit_app/screens/qr_signup_screen.dart';
import 'package:nonprofit_app/screens/widget_setup_screen.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final Widget screen;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.screen,
  });
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static final List<MenuItem> _items = [
    MenuItem(
      icon: Icons.auto_stories,
      title: 'Our Impact',
      screen: const ImpactScreen(),
    ),
    MenuItem(
      icon: Icons.photo_library_outlined,
      title: 'Photo Gallery',
      screen: const GalleryScreen(),
    ),
    MenuItem(
      icon: Icons.play_circle_outlined,
      title: 'Video',
      screen: const VideoScreen(),
    ),
    MenuItem(
      icon: Icons.share_outlined,
      title: 'Share the Mission',
      screen: const ShareScreen(),
    ),
    MenuItem(
      icon: Icons.qr_code,
      title: 'QR Sign-up',
      screen: const QrSignupScreen(),
    ),
    MenuItem(
      icon: Icons.widgets_outlined,
      title: 'Widget Setup',
      screen: const WidgetSetupScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: Text(
                AppConstants.orgName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppConstants.tagline,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    leading: Icon(item.icon, color: AppTheme.primaryColor),
                    title: Text(item.title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => item.screen),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Update `app.dart`**

Change the import from `home_screen.dart` to `menu_screen.dart` and change `home: const HomeScreen()` to `home: const MenuScreen()`.

**Step 3: Commit**

```bash
git add lib/screens/menu_screen.dart lib/app.dart
git commit -m "feat: add menu screen and wire up as app entry point"
```

---

### Task 5: Verify build

**Step 1: Run flutter analyze**

Run: `~/flutter-sdk/bin/flutter analyze`
Expected: No errors (warnings about missing assets are OK since we can't run on device).

**Step 2: Fix any issues if needed**

**Step 3: Final commit if fixes were needed**
