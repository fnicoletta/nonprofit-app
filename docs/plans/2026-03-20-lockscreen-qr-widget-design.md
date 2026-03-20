# Lockscreen QR Code Widget — Design Document

## Overview

A Flutter proof-of-concept app for a nonprofit that displays their story, photos, a video, and a shareable donation link. The app includes a lock screen widget showing a QR code that links directly to the nonprofit's donation page.

The primary goal is to prove the concept works end-to-end, especially the lock screen widget with a scannable QR code on both iOS and Android.

## Architecture

Two parts:

**Main Flutter App** — A single-screen scrollable experience with hardcoded content and placeholder branding. No backend, no auth, no database.

**Native Lock Screen Widgets** — Small widgets on both iOS and Android that display a QR code. Built natively (SwiftUI for iOS, Kotlin for Android) and bridged to Flutter via the `home_widget` package.

### Data Flow

1. Donation URL (with UTM params) is defined as a constant in Flutter
2. On first launch, the app generates a QR code PNG from that URL
3. The PNG is saved to shared storage accessible by the native widget
4. The native widget reads and displays the image
5. Users scanning the QR code are taken to the donation page in their browser

## App Screen Design

Single scrollable screen, top to bottom:

### 1. Hero Section
Full-width banner with placeholder nonprofit logo, org name, and a short tagline. Subtle gradient overlay on a background image.

### 2. Impact Story
A heading ("Our Impact") followed by 2-3 paragraphs of placeholder text telling the nonprofit's story. Simple, readable typography.

### 3. Photo Gallery
Horizontal scrollable row of 4-5 placeholder images. Tapping an image opens it fullscreen. Rounded corners, subtle shadows.

### 4. Video Section
Embedded YouTube player (placeholder video ID). Plays inline.

### 5. Share the Mission
- Short blurb encouraging users to spread the word
- Share button that opens the system share sheet with a pre-written message and the donation link
- Copy link button

### 6. QR Code & Widget Instructions
- The QR code displayed large and scannable
- Step-by-step instructions for adding the widget to the lock screen
- Separate tabs for iOS and Android instructions

## Lock Screen Widgets

### iOS (WidgetKit)
- **Size**: Small (square) — the only size that fits on the iOS lock screen
- **Content**: QR code filling the widget area with thin padding
- **Implementation**: Static `WidgetTimelineProvider` returning a single entry (QR code never changes)
- **Tap behavior**: Opens the main app
- **Storage**: Shared App Group for reading the QR code image

### Android (App Widget)
- **Size**: 2x2 widget for lock screen / home screen
- **Content**: QR code with minimal padding
- **Implementation**: `AppWidgetProvider` with a `RemoteViews` layout containing an `ImageView`
- **Tap behavior**: Opens the main app
- **Storage**: SharedPreferences for the QR code image path

### QR Code Generation
- Generated once on first app launch using `qr_flutter`
- Rendered to PNG and saved to shared storage via `home_widget`
- High error correction level for reliable scanning at small widget sizes
- A short URL is recommended to keep the QR code simple and scannable at small sizes

## Tech Stack

### Flutter Packages
- `qr_flutter` — QR code generation and display
- `home_widget` — Bridge between Flutter and native widgets
- `youtube_player_flutter` — Embedded YouTube video
- `share_plus` — System share sheet
- `url_launcher` — Opening links externally
- `cached_network_image` — Image loading

### Native (iOS)
- SwiftUI Widget extension
- WidgetKit framework
- Shared App Group

### Native (Android)
- Kotlin `AppWidgetProvider`
- XML layout with `ImageView`
- SharedPreferences

## Project Structure

```
lib/
  main.dart
  app.dart
  screens/
    home_screen.dart
  widgets/
    hero_section.dart
    impact_story.dart
    photo_gallery.dart
    video_section.dart
    share_mission.dart
    qr_instructions.dart
  constants/
    app_constants.dart    (donation URL, UTM params, content)
    app_theme.dart        (colors, typography)
ios/
  WidgetExtension/        (SwiftUI widget code)
android/
  app/src/main/.../       (Kotlin widget provider)
assets/
  images/                 (placeholder photos, logo)
```

## Scope

### In Scope
- Single-screen Flutter app with hardcoded content and placeholder branding
- QR code generation with UTM tracking
- Native iOS lock screen widget (SwiftUI/WidgetKit)
- Native Android home/lock screen widget (Kotlin)
- Share functionality for the donation link
- Widget setup instructions within the app

### Out of Scope
- Backend / CMS
- User accounts or authentication
- Push notifications
- Analytics (beyond UTM params)
- App Store / Play Store submission
- Real nonprofit branding or content
