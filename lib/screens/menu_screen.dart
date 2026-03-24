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
